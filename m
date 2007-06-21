Return-Path: <linux-kernel-owner+w=401wt.eu-S1759485AbXFURrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485AbXFURrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758192AbXFURqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:46:53 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53320 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060AbXFURqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:46:52 -0400
Message-ID: <467AB8B0.3040904@zytor.com>
Date: Thu, 21 Jun 2007 10:43:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
 through other means
References: <467994BD.6000403@zytor.com>	 <20070620210343.GQ21478@ftp.linux.org.uk>  <46799A31.10301@zytor.com> <1182442837.3342.13.camel@ram.us.ibm.com> <467AB5EE.3030909@zytor.com>
In-Reply-To: <467AB5EE.3030909@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> I guess I suggest a single comma-separated field with flags and optional
> ":argument":
> 
> 	private
> 	shared:<peer>
> 	slave:<master>
> 	unbindable
> 	overmounted
> 

Just realized: overmounted should presumably have a mount ID associated
with it, too.

	-hpa
