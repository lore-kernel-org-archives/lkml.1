Return-Path: <linux-kernel-owner+w=401wt.eu-S1750816AbZINEA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750816AbZINEA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 00:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750702AbZINEA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 00:00:26 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:38545 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZINEAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 00:00:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Hps383zDs6rRupQ/mHU6cc9P+EnPfVFjzJvk188ZlNLJXGL7uvrrGivLDwvq31RIVZ
         cbDk+MkNsRC2dcFgLrUNQNRAYsoXOtNMW//9XjrIdwH6JFa6VN6+j4djlLgo+eiVnaze
         soemA/V3YLcSAWluImVTg5YzOtmUxIXcbCYNU=
MIME-Version: 1.0
In-Reply-To: <1247591665-12000-1-git-send-email-vapier@gentoo.org>
References: <20090714161416.GA19147@cmpxchg.org> <1247591665-12000-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 13 Sep 2009 23:52:23 -0400
Message-ID: <8bd0f97a0909132052k258eee3fsbb5041fa1d338602@mail.gmail.com>
Subject: Re: [PATCH v2] NOMMU: add support for Memory Protection Units (MPU)
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Bernd Schmidt <bernds_cb1@t-online.de>, Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 13:14, Mike Frysinger wrote:
> From: Bernd Schmidt <bernds_cb1@t-online.de>
>
> Some architectures (like the Blackfin arch) implement some of the
> "simpler" features that one would expect out of a MMU such as memory
> protection.  In our case, we actually get read/write/exec protection
> down to the page boundary so processes can't stomp on each other let
> alone the kernel.  There is a performance decrease (which depends greatly
> on the workload) however as the hardware/software interaction was not
> optimized at design time.

David: anything else need to be done here or can we merge things ?
-mike
