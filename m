Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbZBEP2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbZBEP2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757685AbZBEP2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:28:01 -0500
Received: from kroah.org ([198.145.64.141]:58611 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757637AbZBEP2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:28:00 -0500
Date: Thu, 5 Feb 2009 07:26:30 -0800
From: Greg KH <greg@kroah.com>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       balajirrao@gmail.com, laurent.riffard@free.fr, balajirrao@openmoko.org
Subject: Re: linux-next: Tree for March 7: slab corruptions
Message-ID: <20090205152630.GB4099@kroah.com>
References: <498A7463.4010603@intel.com> <20090205053802.GA8355@kroah.com> <498A94E0.2080306@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498A94E0.2080306@intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 03:27:28PM +0800, Zhao, Yu wrote:
> Greg KH wrote:
>> On Thu, Feb 05, 2009 at 01:08:51PM +0800, Zhao, Yu wrote:
>>> Hi Greg,
>>>
>>> It looks like following fix is not in Linus' tree. Can you please queue 
>>> it?
>>>
>>> http://lkml.org/lkml/2008/3/8/155
>> Queue what?  That is a message from over a year ago, are you seeing a
>> problem in mainline in this area?  If so, do you have a proposed fix for
>> it?
>
> Yes, I'm seeing 'kobject (ffff8800bf03b908): tried to init an initialized
> object, something is seriously wrong'. The warning is fired when 
> re-initializing
> a kobject that has been deleted while its state remains `initialized'. 

What kobject is causing this to happen?

kobjects should not be static, which it sounds like is the root of your
problem here.  If they are properly dynamic, this can not happen.

thanks,

greg k-h
