Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbXJ3LIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbXJ3LIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXJ3LIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:08:41 -0400
Received: from il.qumranet.com ([82.166.9.18]:49791 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbXJ3LIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:08:40 -0400
Message-ID: <47271057.5040102@qumranet.com>
Date: Tue, 30 Oct 2007 13:07:03 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Carsten Emde <Carsten.Emde@osadl.org>, kvm-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] 2.6.23.1-rt4 and kvm 48
References: <9c21eeae0710290709x527cf4fcq52bb410907ff496@mail.gmail.com>	<4726B088.1010709@qumranet.com> <4726DF66.4000000@osadl.org> <4726FE2A.1040607@siemens.com>
In-Reply-To: <4726FE2A.1040607@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> Interesting result - you've read about the wbinvd issues? Is there no
> wbinvd in the bios shipped with older kvm? Which VM extension did you
> test, both Intel and AMD? I would bet that your X issues are due to the
> same effect. X startup/shutdown involves a lot of wbinvd calls on my
> test boxes.
>
>   

kvm.git now traps invd and wbinvd on amd, so there shouldn't be any 
issues there.  I hope that Intel will add similar traps in future 
iterations of VT.


-- 
Any sufficiently difficult bug is indistinguishable from a feature.

