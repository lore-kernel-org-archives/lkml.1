Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZCKNqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZCKNqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbZCKNqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:46:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56952 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753850AbZCKNqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:46:08 -0400
Date: Wed, 11 Mar 2009 13:46:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, arobinso@nyx.net
Subject: Re: [PATCH 29/31] esp: Auto-load esp module when device opened.
Message-ID: <20090311134649.00e77e2e@lxorguk.ukuu.org.uk>
In-Reply-To: <6a6e566959d30a7e03d677bcb5f68f71d1988e9d.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
	<6a6e566959d30a7e03d677bcb5f68f71d1988e9d.1236702228.git.scott@canonical.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Mar 2009 20:55:52 -0700
Tim Gardner <tim.gardner@canonical.com> wrote:

> The esp module is missing the char-major-57-* alias that would cause it
> to be auto-loaded when a device of that type is opened.  This patch adds
> the alias.

NAK - the default esp behaviour is to do unsafe ISA probes to find the
ports. We don't want it autoloading therefore.
