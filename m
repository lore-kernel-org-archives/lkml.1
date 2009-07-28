Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbZG1PBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbZG1PBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZG1PBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:01:48 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55054 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbZG1PBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:01:47 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] Staging: hv: Transform PDEVICE_OBJECT and DEVICE_OBJECT typedefs into their corresponding structs
Date: Tue, 28 Jul 2009 17:01:42 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: hjanssen@microsoft.com, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200907281030.45317.npalix@diku.dk> <20090728144123.GB13883@suse.de>
In-Reply-To: <20090728144123.GB13883@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907281701.43509.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 July 2009 16:41:23 Greg KH wrote:
> On Tue, Jul 28, 2009 at 10:30:44AM +0200, Nicolas Palix wrote:
> > 
> > Remove typedef DEVICE_OBJECT and use a struct with the same name
> > instead. The new struct name uses lower case (struct device_object).
> 
> This should be called "struct hv_device" instead, care to respin the
> patch like that to keep us from having to change it again?  :)
> 
> thanks,
> 
> greg k-h
> 
Ok. So, I guess the pattern for the other typedef is to strip the _OBJECT
suffix when present, and always add the prefix hv_, right ?

-- 
Nicolas Palix
