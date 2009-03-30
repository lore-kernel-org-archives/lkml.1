Return-Path: <linux-kernel-owner+w=401wt.eu-S1761234AbZC3VN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761234AbZC3VN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758216AbZC3VNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:13:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758317AbZC3VNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:13:10 -0400
Date: Mon, 30 Mar 2009 14:10:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Purushotam Kumar <purushotam@ti.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
       linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx, purushotam@ti.com
Subject: Re: [PATCH 1/1] DaVinci: MMC: Updated MMC/SD controller driver for
 DaVinci family.
Message-Id: <20090330141037.f473bf99.akpm@linux-foundation.org>
In-Reply-To: <1237378885-5918-1-git-send-email-purushotam@ti.com>
References: <1237378885-5918-1-git-send-email-purushotam@ti.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009 17:51:25 +0530
Purushotam Kumar <purushotam@ti.com> wrote:

> This patch adds support for MMC/SD controller driver for DaVinci family SoC.
> This patch will work for SoC like DM6446 and DM355. SoC like DM365 and
> DA830 also has same controller with small variations and could supported/added 
> easily by using this version of patch. It means that this version of patch 
> could be used for all SoC which has been derived from DaVinci family.
>  
> This patch has been generated against latest 2.6.29 mainline kernel. This patch
> will not compile currently because it depends notably on the EDMA utilities and
> chip/board setup, that will come at some point through the ARM tree. Please use
> currently DaVinci GIT tree for EDMA utilities and chip/board setup etc.

The wont-compile thing makes it a bit hard for me to merge.

Specifically where are these prerequisite patches and how will I know
when they are available and in what tree?

Perhaps the simplest approach would be for you to wait until the code
_will_ compile?


