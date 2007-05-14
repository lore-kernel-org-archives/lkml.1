Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbXENGPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbXENGPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 02:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621AbXENGPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 02:15:12 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:45279 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969AbXENGPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 02:15:11 -0400
Message-ID: <4647FE70.7090700@vmware.com>
Date: Sun, 13 May 2007 23:15:12 -0700
From: Petr Vandrovec <petr@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.3) Gecko/20070217 Iceape/1.1.1 (Debian-1.1.1-2)
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [OT] Re: patch for vmware for Linux-2.6.21
References: <b6a2187b0705131818x556eb57me42d1811e0db7a04@mail.gmail.com>	 <1179106529.19106.6.camel@laptopd505.fenrus.org> <b6a2187b0705132019x579bf28fq5110812432a3b591@mail.gmail.com>
In-Reply-To: <b6a2187b0705132019x579bf28fq5110812432a3b591@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> On 5/14/07, Arjan van de Ven <arjan@infradead.org> wrote:
>> On Mon, 2007-05-14 at 09:18 +0800, Jeff Chua wrote:
> 
>> I'm sorry... but why are you posting these patches here? Those aren't
>> GPL modules, and thus very offtopic for lkml, maybe except for if you
>> want to deliberately have people look at non-gpl code ;(
> 
> I don't like these non-gpl code myself, but it allowed me to use
> Linux-2.6.22 as a base to test the new kvm and hope to migrate to kvm
> soon, and I'm sure some others out there would benefit from it as
> well. I don't claim the code to be perfect, but by releasing to
> others, hopefully someone can tell me where to improve on.

I would strongly recommend you using my patches from 
http://platan.vc.cvut.cz/ftp/pub/vmware/vmware-any-any-update110.tar.gz. 
  Patch you've created causes memory corruption on 2.6.22-rc1 (and few 
previous kernels, since csum_start got introduced).
					Best regards,
						Petr Vandrovec

