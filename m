Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbYBYAF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbYBYAF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYBYAFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:05:14 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1951 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbYBYAFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:05:12 -0500
Subject: Re: [PATCH 2/3] IDE: Replace __FUNCTION__ with __func__
From: Joe Perches <joe@perches.com>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <20080224221113.5ddfe371@paolo-desktop>
References: <20080224221113.5ddfe371@paolo-desktop>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 16:04:48 -0800
Message-Id: <1203897888.19319.143.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-02-24 at 22:11 +0100, Paolo Ciarrocchi wrote:
> -				"driver.\n", __FUNCTION__, drive->name);
> +				"driver.\n", __func__, drive->name);

Is there consensus on this style conversion?

Right now, there's 629 uses of __FUNCTION__ and 439 uses of __func__.


