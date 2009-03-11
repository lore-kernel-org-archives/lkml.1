Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbZCKNuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbZCKNuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbZCKNuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:50:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51733 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755287AbZCKNuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:50:06 -0400
Date: Wed, 11 Mar 2009 13:50:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Scott James Remnant <scott@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 30/31] mwave: Auto-load mwave module when device opened.
Message-ID: <20090311135059.79acaa82@lxorguk.ukuu.org.uk>
In-Reply-To: <20648ad5975623975f64a3d834dad597014f0473.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
	<20648ad5975623975f64a3d834dad597014f0473.1236702228.git.scott@canonical.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Mar 2009 15:31:24 +0000
Scott James Remnant <scott@canonical.com> wrote:

> The mwave module is missing the char-major-10-219 alias that would cause
> it to be auto-loaded when a device of that type is opened.  This patch
> adds the alias

NAK - another one we don't want autoprobing by default.
