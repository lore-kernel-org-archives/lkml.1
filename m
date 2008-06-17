Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbYFRJCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbYFRJCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 05:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYFRJBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 05:01:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2392 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751261AbYFRJBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 05:01:53 -0400
Date: Tue, 17 Jun 2008 20:53:45 +0200
From: Pavel Machek <pavel@suse.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: rui.zhang@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch v2] Implement thermal limiting in the generic thermal class
Message-ID: <20080617185345.GA5847@ucw.cz>
References: <20080611100647.GA20013@srcf.ucam.org> <20080616085544.GA17813@srcf.ucam.org> <20080616092648.GA18506@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616092648.GA18506@srcf.ucam.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> In the absence of an explicitly defined passive cooling zone any                                                                                                                                        
> machine unable to manage its thermal profile through active cooling will                                                                                                                                
> reach its critical shutdown temperature and power off, resulting in                                                                                                                                     
> potential data loss. Add support to the generic thermal class for                                                                                                                                       
> initiating passive cooling at a temperature defaulting to just below the                                                                                                                                
> critical temperature, with this value being overridable by the admin via                                                                                                                                
> sysfs.                                                                             

This means we get two copies of passive cooling code: one generic, and
one in acpi. Can we make sure we have just one of them?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
