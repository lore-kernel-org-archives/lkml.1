Return-Path: <linux-kernel-owner+w=401wt.eu-S936797AbXGSI03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936797AbXGSI03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 04:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932236AbXGSIYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:24:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42162 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758467AbXGSIY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:24:27 -0400
Date: Thu, 19 Jul 2007 01:21:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Airlie" <airlied@gmail.com>
Cc: "David Miller" <davem@davemloft.net>, airlied@linux.ie,
       linux-kernel@vger.kernel.org
Subject: Re: cmpxchg is not available to generic code
Message-Id: <20070719012141.47911bd7.akpm@linux-foundation.org>
In-Reply-To: <21d7e9970707190115r15e691d5s123c9889a8ebd8a5@mail.gmail.com>
References: <20070719000549.1e57b5b2.akpm@linux-foundation.org>
	<20070719.002716.30181989.davem@davemloft.net>
	<21d7e9970707190115r15e691d5s123c9889a8ebd8a5@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 18:15:03 +1000 "Dave Airlie" <airlied@gmail.com> wrote:

> Maybe we could add CONFIG_HAVE_CMPXCHG and let DRM depend on it..

That would certainly be better than adding a sprinkle of architectures
in DRM Kconfig dependencies.

I don't know how important DRM is on ARM.  Zero?
