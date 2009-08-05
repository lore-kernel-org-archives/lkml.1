Return-Path: <linux-kernel-owner+w=401wt.eu-S964802AbZHEQ2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802AbZHEQ2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934641AbZHEQ2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:28:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:60050 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934628AbZHEQ2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:28:39 -0400
Message-ID: <4A79B3A6.7090109@kernel.org>
Date: Thu, 06 Aug 2009 01:30:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Al Viro <viro@ftp.linux.org.uk>, Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 1/2] chrdev: implement __[un]register_chrdev()
References: <4A79283E.7030202@kernel.org> <20090805161643.GA28436@kroah.com>
In-Reply-To: <20090805161643.GA28436@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Aug 2009 16:28:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Aug 05, 2009 at 03:35:42PM +0900, Tejun Heo wrote:
>> [un]register_chrdev() assume minor range 0-255.  This patch adds __
>> prefixed versions which take @minorbase and @count explicitly.
> 
> What's the difference between this and the existing
> register_chrdev_region() function?  Why doesn't that work for you?
> 
> What am I missing here?

The function names in char_dev.c are quite confusing.
register_chrdev_region() only registers chrdev region.
register_chrdev() registers chrdev region and creates a cdev for the
region.  :-)

-- 
tejun
