Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294AbXDXXkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbXDXXkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 19:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbXDXXkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 19:40:46 -0400
Received: from hu-out-0506.google.com ([72.14.214.226]:64203 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbXDXXkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 19:40:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Q649uV9DZFCdchx/NQlHim+0Lyg9dR63PeaETC17zpgjwpX4LIAni/OOcR1hRBkEPRrAk3hvu3Q4BH9OPVegM+JoQanjtjBtAdRrbL4fDgHf9UG5eixIHPYbQsSxQiW1Qg6wgrtkTn6CoLsLVt5CZ6EvmxhmAV2K6jXdgdGefPQ=
Message-ID: <f4e013870704241640q5a723664l2fda780a24f9b40e@mail.gmail.com>
Date: Tue, 24 Apr 2007 16:40:42 -0700
From: "Mark Hull-Richter" <mhullrich@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel traces coming back with trash/clutter
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am experimenting with the kernel (CentOSv4.4 x86_64, 2.6.9-42.0.10)
and I have added a number of traces in some relatively sensitive code
in the page cache and some i/o functions.

I am getting this odd content in the trace log (dmesg), and I cannot
figure out what it is or why it is there.

4296757675 pdflush(80): do_writepages: map>ops>wrtpgs ffffffffa0195ff5
4296757675 pdflush(80): mpage_writepages w/b index 49728 pages 256000
<7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7>
<7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7>
<7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7>
<7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7>
<7><7><7><7><7>__bio_add_page: 2x ph 88>=128 || hw 88>=88 || 360448>max
ffffffff802525d8 generic_make_request(bio 000001017c745300) 50729472, 704
__make_request(q 00000101b9293870, bio 000001017c745300: sdc; 50729600, 704)
ll_new_hw_segment: 70 + 29 > 88
<7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7>
<7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7>
<7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7>
<7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7>
<7><7><7><7>__bio_add_page: 2x ph 88>=128 || hw 88>=88 || 360448>max
ffffffff802525d8 generic_make_request(bio 000001017c745a80) 50730176, 704
__make_request(q 00000101b9293870, bio 000001017c745a80: sdc; 50730304, 704)
4296757684 swapper(0): dl_mv2dsp: sdc start 50710368 secs 1408

(The lines with the <7>s in them are long - I wrapped them for ease of
reading and to keep the width down somewhat.)

Any feedback that might illuminate this would be welcome.  Please CC
me personally as I am not yet able to subscribe to this list
(apologies).

Thanks.

--
Mark Hull-Richter, Linux Kernel Engineer
DATAllegro (www.datallegro.com)
85 Enterprise, Second Floor, Aliso Viejo, CA  92656
949-680-3082 - Office     949-330-7691 - fax
