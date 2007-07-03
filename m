Return-Path: <linux-kernel-owner+w=401wt.eu-S1760247AbXGCVca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbXGCVca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759446AbXGCVcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:32:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758322AbXGCVcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:32:09 -0400
Message-ID: <468AC017.2000300@redhat.com>
Date: Tue, 03 Jul 2007 17:31:03 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Juan Antonio Martinez <jonsito@teleline.es>
CC: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>
Subject: Re: ppdev - libieee1284.so  conflicts with 2.6.21
References: <1183443365.3006.10.camel@drake.micasa.es>
In-Reply-To: <1183443365.3006.10.camel@drake.micasa.es>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2007 02:16 AM, Juan Antonio Martinez wrote:
> Attached 3 reports:
> 2.6.21 with noisapnp pnpacpi=off
> 2.6.21 without extra options
> 2.6.20
> 
> I apologize for sending reports with fedora (not vanilla) kernels. I
> have not enought time to recompile and test
> 
> By diffin'g reports, I've found these significant ( to me) difference in
> 2.6.20:
> 
> < ppdev0: registered pardevice
> < ppdev0: negotiated back to compatibility mode because user-space
> forgot
> < ppdev0: unregistered pardevice

When it is working it says:

ppdev: user-space parallel port driver
ppdev0: registered pardevice
ppdev0: unregistered pardevice
ppdev0: registered pardevice
ppdev0: negotiated back to compatibility mode because user-space forgot
ppdev0: unregistered pardevice
ppdev0: registered pardevice
ppdev0: unregistered pardevice

When broken:

ppdev: user-space parallel port driver
ppdev0: registered pardevice
ppdev0: unregistered pardevice

I give up, what causes that?
