Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbYIQIgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbYIQIgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 04:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbYIQIfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 04:35:42 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:55701 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbYIQIfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 04:35:39 -0400
Message-ID: <48D0C157.7050406@nttdata.co.jp>
Date: Wed, 17 Sep 2008 17:35:35 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.16) Gecko/20080708 Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Toshiharu Harada <haradats@nttdata.co.jp>
Subject: Re: [PATCH] Introduce new LSM hooks where vfsmount is available.
References: <48C65E9D.3070106@nttdata.co.jp>	<5fb14edc0809090902m32431bf6yf518a457e410764d@mail.gmail.com> <20080910134540.45ec1272.akpm@linux-foundation.org> <48C877DE.4040402@nttdata.co.jp> <48D06865.8070602@nttdata.co.jp> <48D080D1.5060405@schaufler-ca.com>
In-Reply-To: <48D080D1.5060405@schaufler-ca.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2008 08:35:35.0471 (UTC) FILETIME=[5AD803F0:01C918A0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> As always, the community will be eager to see the code that makes
> use of these hooks.
We are ready for submitting body of TOMOYO Linux as always. :-)
However, the largest stumbling block of merging TOMOYO Linux is the
method for calculating pathname in LSM module. This patch contains
all modifications to the existing kernel code by TOMOYO Linux (the
rest modification is within security/tomoyo).

We'd like to ask the community's approval of this approach before
review of TOMOYO Linux main module.

Regards,

