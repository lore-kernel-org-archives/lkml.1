Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbXJ3LfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbXJ3LfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbXJ3Ley
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:34:54 -0400
Received: from gecko.sbs.de ([194.138.37.40]:20379 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926AbXJ3Lew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:34:52 -0400
Message-ID: <472716C1.1090102@siemens.com>
Date: Tue, 30 Oct 2007 12:34:25 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: kvm-devel@lists.sourceforge.net, Carsten Emde <Carsten.Emde@osadl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] 2.6.23.1-rt4 and kvm 48
References: <9c21eeae0710290709x527cf4fcq52bb410907ff496@mail.gmail.com>	<4726B088.1010709@qumranet.com>	<4726DF66.4000000@osadl.org> <4726FE2A.1040607@siemens.com> <47271057.5040102@qumranet.com>
In-Reply-To: <47271057.5040102@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Jan Kiszka wrote:
>> Interesting result - you've read about the wbinvd issues? Is there no
>> wbinvd in the bios shipped with older kvm? Which VM extension did you
>> test, both Intel and AMD? I would bet that your X issues are due to the
>> same effect. X startup/shutdown involves a lot of wbinvd calls on my
>> test boxes.
>>
>>   
> 
> kvm.git now traps invd and wbinvd on amd, so there shouldn't be any 
> issues there. 

So kvm can then simply ignore the instructions, or what does it do about
them? I recall some replies in the related thread that some more work
may be required.

> I hope that Intel will add similar traps in future 
> iterations of VT.

Yep.

Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
