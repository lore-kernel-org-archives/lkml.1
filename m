Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbZF2M6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbZF2M6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 08:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZF2M6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 08:58:23 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:49171 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZF2M6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:58:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ityIOSuYdl56KD2DFa2atTiS0IHKlS+GqLL28fr46AiUpMogsBA7TPjDkmIsvCaW+C
         oct/4FB/mRoKisDPkLlkJWruumUt64UH7sRMvBL6X2ejd6eKo/eCcF0wO1ezs0AdLxJf
         JfC1v5f0YphEUO5J4tW25NeX2hJotk1Ub3J2E=
MIME-Version: 1.0
In-Reply-To: <20090629125434.GA8416@localhost>
References: <6.0.0.20.2.20090601095926.06ee98d8@172.19.0.2>
	 <20090606233056.7B9F.A69D9226@jp.fujitsu.com>
	 <20090606224538.GA6173@localhost>
	 <20090618120436.ad3196e3.akpm@linux-foundation.org>
	 <20090620035504.GA19516@localhost> <4A3CD62B.1020407@vlnb.net>
	 <20090629093423.GB1315@localhost>
	 <a0272b440906290326rcd63849j2513f6ee9b9bf93e@mail.gmail.com>
	 <4A489DAC.7000007@vlnb.net> <20090629125434.GA8416@localhost>
Date: Mon, 29 Jun 2009 14:58:24 +0200
Message-ID: <e2e108260906290558s59bc0475r713952fca6fa71d@mail.gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>,
       Ronald Moesbergen <intercommit@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "Alan.Brunelle@hp.com" <Alan.Brunelle@hp.com>,
       "hifumi.hisashi@oss.ntt.co.jp" <hifumi.hisashi@oss.ntt.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 2:54 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> Is blockdev-perftest public available? It's not obvious from google search.

This script is publicly available. You can retrieve it by running the
following command:
svn co https://scst.svn.sourceforge.net/svnroot/scst/trunk/scripts

Bart.
