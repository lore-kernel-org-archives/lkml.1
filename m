Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbZHRL7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbZHRL7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 07:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758769AbZHRL67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 07:58:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758664AbZHRL65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 07:58:57 -0400
Date: Tue, 18 Aug 2009 13:58:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-usb@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbhid/hid-code.c: local function should be static
In-Reply-To: <200908171537.18923.hartleys@visionengravers.com>
Message-ID: <alpine.LNX.2.00.0908181358220.25797@wotan.suse.de>
References: <200908171537.18923.hartleys@visionengravers.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009, H Hartley Sweeten wrote:

> __usbhid_submit_report() is a local function wrapped by the exported
> symbol usbhid_submit_report(). As such, it should be static.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
