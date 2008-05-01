Return-Path: <linux-kernel-owner+w=401wt.eu-S933841AbYEAXKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841AbYEAXKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933432AbYEAXHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:07:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933384AbYEAXHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:07:22 -0400
Date: Thu, 1 May 2008 16:07:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] video: fix integer as NULL pointer warnings
Message-Id: <20080501160720.6481ef61.akpm@linux-foundation.org>
In-Reply-To: <1209593021.24729.114.camel@brick>
References: <1209593021.24729.114.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 15:03:41 -0700
Harvey Harrison <harvey.harrison@gmail.com> wrote:

>
> Subject: [PATCH 04/10] video: fix integer as NULL pointer warnings
>
>  drivers/video/aty/atyfb_base.c       |    2 +-
>  drivers/video/aty/radeon_base.c      |    2 +-
>  drivers/video/matrox/matroxfb_base.h |    2 +-
>  drivers/video/sis/sis_main.c         |    2 +-

drivers/video is called "fbdev", believe it or not.  To avoid confusion
with drivers/media/video, which is called dvb.  Or v4l.

