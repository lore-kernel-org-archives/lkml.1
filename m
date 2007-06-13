Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbXFMAAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbXFMAAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 20:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbXFMAAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 20:00:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52598 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbXFMAAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 20:00:30 -0400
Date: Wed, 13 Jun 2007 01:00:29 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix empty macros in acpi.
Message-ID: <20070613000029.GK21478@ftp.linux.org.uk>
References: <20070612233309.GA24251@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612233309.GA24251@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 07:33:09PM -0400, Dave Jones wrote:
> +#define DBG(x...) do { } while(0)

Eh...  Please, stop it - if you want a function-call-like no-op returning void,
use ((void)0).  At least that way one can say DBG(....),foo(), etc.

