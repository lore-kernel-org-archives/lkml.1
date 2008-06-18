Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbYFRRou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbYFRRou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 13:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYFRRol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 13:44:41 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:32972 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbYFRRok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 13:44:40 -0400
Subject: Re: [PATCH 01/11] sysfs: Support for preventing unmounts.
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Benjamin Thery <benjamin.thery@bull.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
In-Reply-To: <20080618170730.256129077@theryb.frec.bull.fr>
References: <20080618170729.808539948@theryb.frec.bull.fr>
	 <20080618170730.256129077@theryb.frec.bull.fr>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 10:44:23 -0700
Message-Id: <1213811063.7922.39.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-18 at 19:07 +0200, Benjamin Thery wrote:
> To support mounting multiple instances of sysfs occassionally I
> need to walk through all of the currently present sysfs super blocks.

I know you may have addressed this before, but I forgot and it didn't
make it into the changelogs.

Why are you doing this again?  It seems like an awfully blunt
instrument.  

-- Dave

