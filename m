Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbZEDNTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbZEDNTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 09:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbZEDNSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 09:18:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:3474 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbZEDNSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 09:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=E0sTdJn9f/rZGSuQfELAWuoH7xMobQErAWlXORBQdW0xgrdpBbklng71KAGnCfp4PS
         e6MXhkxZiPdprzKeieY2wFPCHLmcI50tCzBsaG53gira9WjN9rVArrdUkTidDLR28iQ2
         YfZn4ofaxaMMZiULeB4z8yA/qxxwWa/szQ3Bo=
MIME-Version: 1.0
In-Reply-To: <2891419e0905040356x53643144of77eeaa8c210dce7@mail.gmail.com>
References: <2891419e0905040356x53643144of77eeaa8c210dce7@mail.gmail.com>
From: Chris Snook <chris.snook@gmail.com>
Date: Mon, 4 May 2009 09:18:37 -0400
Message-ID: <13a12eea0905040618u7fc48755hdbc3ea6d87c4d68c@mail.gmail.com>
Subject: Re: [PATCH 0/2] range-bw : Another I/O scheduling policy of dm-ioband 
	(v1)
To: Dong-Jae Kang <baramsori72@gmail.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, righi.andrea@gmail.com,
       menage@google.com, balbir@linux.vnet.ibm.com,
       guijianfeng@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       chlunde@ping.uio.no, dave@linux.vnet.ibm.com, dpshah@google.com,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp, taka@valinux.co.jp,
       lizf@cn.fujitsu.com, matt@bluehost.com, dradford@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, nauman@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, corsetproject@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 4, 2009 at 6:56 AM, Dong-Jae Kang <baramsori72@gmail.com> wrote:
> range-bw has two kinds of operation modes, min-max and max mode.
> Min-max mode is to supports guaranteeing the minimum I/O requirement
> and limitation of unnecessary I/O bandwidth at the same time. And max
> mode is to support only limitation. So in case of min-max mode, you
> need to configure min-bw and max-bw values and in case of max mode,
> configure only max-bw.

Please forgive me if I missed a previous discussion, but how is max
mode different from min-max mode with a minimum of zero?  I understand
that there may be some special-case optimizations you can do
internally, but it's unclear to me why you need two different
interfaces.

-- Chris
