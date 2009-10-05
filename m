Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbZJEPkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbZJEPkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 11:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZJEPku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 11:40:50 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:58832 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZJEPkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 11:40:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=URIgi1uGpqY8au1Tbbq8MJuMQF4UPnFIVEcgRkB/m8169bOaH0xAA0Mu8iZizWSgE8
         A3CLbugL5McCMZNWEJu7aBL2JNaHMrinXlXCAw51Ibz8bUIOqx+GGa2hgsPtbNpIci1r
         R2fm06FxnCvv40IbGOFYNoE48DtLFWR6p+tgY=
Message-ID: <4ACA1354.1000403@gmail.com>
Date: Mon, 05 Oct 2009 17:40:04 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.1 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Alasdair G Kergon <agk@redhat.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: Re: linux-next: manual merge of the device-mapper tree with Linus'
 tree
References: <20091005144102.8c012c56.sfr@canb.auug.org.au>
In-Reply-To: <20091005144102.8c012c56.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2009 05:41 AM, Stephen Rothwell wrote:
> Today's linux-next merge of the device-mapper tree got a conflict in
> drivers/md/dm-log-userspace-transfer.c between commit
> 18366b05a00349c1606269ba7422bf9b3a357ff2 ("connector/dm: Fixed a
> compilation warning") from Linus' tree and commit
> 584ac98acfc033dfda338641e736b0100fd31909
> ("dm-log-fix-cn_ulog_callback-declaration") from the device-mapper tree.
> 
> The former commit (already in Linus' tree) supersedes the latter, so I
> used the former.

Hmm, great! I sent it month and a half earlier with proper changelog and
meaningful subject. akpm sent it twice with davem in Cc. davem merged
that one instead.

/me demotivated to post such fixes again.
