Return-Path: <linux-kernel-owner+w=401wt.eu-S1031132AbXD3Twh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031132AbXD3Twh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031126AbXD3Twh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:52:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031110AbXD3Twg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:52:36 -0400
Message-ID: <46364901.4000907@redhat.com>
Date: Mon, 30 Apr 2007 15:52:33 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates
References: <20070429161542.GA12501@havoc.gtf.org>
In-Reply-To: <20070429161542.GA12501@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> 
> Jeff Garzik (8):
>       libata/IDE: remove combined mode quirk

You can't just remove the "combined_mode=" kernel parameter or
every Linux user who uses that will get an unbootable kernel
with no good way of diagnosing the problem. It should still
be accepted and just print a warning.

