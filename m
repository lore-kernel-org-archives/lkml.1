Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbZG1Oom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbZG1Oom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 10:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZG1Ool
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 10:44:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbZG1Ool (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 10:44:41 -0400
Date: Tue, 28 Jul 2009 07:41:23 -0700
From: Greg KH <gregkh@suse.de>
To: Nicolas Palix <npalix@diku.dk>
Cc: hjanssen@microsoft.com, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: hv: Transform PDEVICE_OBJECT and
 DEVICE_OBJECT typedefs into their corresponding structs
Message-ID: <20090728144123.GB13883@suse.de>
References: <200907281030.45317.npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907281030.45317.npalix@diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 10:30:44AM +0200, Nicolas Palix wrote:
> 
> Remove typedef DEVICE_OBJECT and use a struct with the same name
> instead. The new struct name uses lower case (struct device_object).

This should be called "struct hv_device" instead, care to respin the
patch like that to keep us from having to change it again?  :)

thanks,

greg k-h
