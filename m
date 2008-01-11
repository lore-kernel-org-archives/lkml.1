Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYAKDS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYAKDS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 22:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756427AbYAKDSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 22:18:21 -0500
Received: from foo.birdnet.se ([213.88.146.6]:40779 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755912AbYAKDSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 22:18:20 -0500
X-Greylist: delayed 511 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2008 22:18:19 EST
Message-ID: <20080111030945.27954.qmail@cdy.org>
Date: Fri, 11 Jan 2008 04:09:45 +0100
From: Peter Stuge <stuge-linux-pcmcia@cdy.org>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Mathieu Segaud <mathieu.segaud@regala.cx>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] [Coding Style]: fs/ext{3,4}/ext{3,4}_jbd{,2}.c
Mail-Followup-To: Roel Kluin <12o3l@tiscali.nl>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Mathieu Segaud <mathieu.segaud@regala.cx>,
	Richard Knutsson <ricknu-0@student.ltu.se>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-2-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-3-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-4-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-5-git-send-email-mathieu.segaud@regala.cx> <477E379F.4000103@student.ltu.se> <20080105041228.GP3351@webber.adilger.int> <20080105051817.GD27894@ZenIV.linux.org.uk> <4786883E.30604@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4786883E.30604@tiscali.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 10:03:58PM +0100, Roel Kluin wrote:
> -#define DEBUG(x,args...)	printk(__FUNCTION__ ": " x,##args)
> +#define DEBUG(x, args...)	printk("%s: ", __func__, x, ##args)

Can this really be expected to work when x contains conversions?

How about:

#define DEBUG(x, args...) printk("%s: " x, __func__, ##args)


//Peter
