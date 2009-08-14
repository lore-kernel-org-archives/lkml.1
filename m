Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbZHNETV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbZHNETV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 00:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZHNETU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 00:19:20 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:40816 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZHNETT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 00:19:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=uJjxcntIEEZHcvURhMg+6tAS1x2inDAOmwoIZkrg51OMWyPxuQgrhDTSzhdF6+NF/K
         TfTmn9IyJjg3VxwLNSZUDS4Wh/gJQC+rA/9/v06Q+FE3kF+7pldDmmIsYpmE8Ms00Zc+
         GP0g2YKsX7554XVJEaRLEvl6CyEkm/7+Co1sY=
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] mmotm0812 - something in linux-next killed iwl-3945.c
References: <19728.1250182794@turing-police.cc.vt.edu>
	<20090813172819.GD2647@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 14 Aug 2009 07:19:17 +0300
In-Reply-To: <20090813172819.GD2647@tuxdriver.com> (John W. Linville's message of "Thu\, 13 Aug 2009 13\:28\:19 -0400")
Message-ID: <87zla3hvsq.fsf@litku.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"John W. Linville" <linville@tuxdriver.com> writes:

> On Thu, Aug 13, 2009 at 12:59:54PM -0400, Valdis.Kletnieks@vt.edu wrote:
>> Build bombs out:
>> 
>>   CC      drivers/net/wireless/iwlwifi/iwl-3945.o
>> drivers/net/wireless/iwlwifi/iwl-3945.c: In function 'iwl3945_pass_packet_to_mac80211':
>> drivers/net/wireless/iwlwifi/iwl-3945.c:580: error: 'hdr' undeclared (first use in this function)

[...]

>> Sorry, don't have a linux-next git tree, so no 'git blame' for what did it.
>> Hopefully somebody recognizes their handiwork... ;)
>
> I think this is the LEDS-related build failure, which already has a patch.

Correct. This patch fixes it:

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=44f282ff0e3797555e9ac54d8a772b65f72e3702

-- 
Kalle Valo
