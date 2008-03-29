Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbYC2BHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbYC2BHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 21:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbYC2BHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 21:07:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33314 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbYC2BHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 21:07:17 -0400
Message-ID: <47ED963E.3060709@zytor.com>
Date: Fri, 28 Mar 2008 18:07:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: "John T." <j.thomast@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: UTF-8 and Alt key in the console
References: <205509.99433.qm@web45710.mail.sp1.yahoo.com> <alpine.LNX.1.00.0803231942380.3157@fbirervta.pbzchgretzou.qr> <47ED7EBD.8070009@zytor.com> <alpine.LNX.1.10.0803290055270.18418@fbirervta.pbzchgretzou.qr> <47ED8C13.5060509@zytor.com> <alpine.LNX.1.10.0803290143180.18418@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0803290143180.18418@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
>>
>> I think it would be a major lose to move away from ISO 6429 format; 
>> the format is self-terminating and really isn't all that complex.
> 
> What do you mean by self-terminating? There is no easy
> synchronization like in UTF-8, given you are anywhere inside
> a text stream, how do you know (a) you are already in an
> escape sequence and (b) how to figure out the rebegin of
> normal text.

(a) isn't readily supported (other than scanning backwards), but (b) is 
pretty easy, see ISO 6429.

	-hpa
