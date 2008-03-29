Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYC2RF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYC2RF1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbYC2RFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:05:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33925 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbYC2RFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:05:18 -0400
Message-ID: <47EE76BD.2000708@zytor.com>
Date: Sat, 29 Mar 2008 10:05:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>, "John T." <j.thomast@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: UTF-8 and Alt key in the console
References: <205509.99433.qm@web45710.mail.sp1.yahoo.com> <alpine.LNX.1.00.0803231942380.3157@fbirervta.pbzchgretzou.qr> <47ED7EBD.8070009@zytor.com> <alpine.LNX.1.10.0803290055270.18418@fbirervta.pbzchgretzou.qr> <47ED8C13.5060509@zytor.com> <alpine.LNX.1.10.0803290143180.18418@fbirervta.pbzchgretzou.qr> <47EDE2A4.8080702@davidnewall.com>
In-Reply-To: <47EDE2A4.8080702@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Jan Engelhardt wrote:
>> What do you mean by self-terminating? There is no easy
>> synchronization like in UTF-8, given you are anywhere inside
>> a text stream, how do you know (a) you are already in an
>> escape sequence and (b) how to figure out the rebegin of
>> normal text.
> 
> It's not very useful being able to tell you are inside a escape sequence
> unless you see that sequence from the start.  You do need the complete
> sequence to make sense of it.

I think what Jan is alluding to is the property of UTF-8 text that you 
can start in the middle of a string and either skip an incomplete 
character or find the beginning of it.  If you can search backwards, you 
can find the beginning of an escape sequence, too; the "skip incomplete" 
  functionality is missing, though, but as you say, isn't actually all 
that useful in real life *for the applications which use these kinds of 
escape sequences.*

	-hpa
