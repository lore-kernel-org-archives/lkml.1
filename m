Return-Path: <linux-kernel-owner+w=401wt.eu-S932380AbZHZLx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbZHZLx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbZHZLx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:53:27 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:59547 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496AbZHZLx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:53:26 -0400
Message-ID: <4A9521CA.80102@csr.com>
Date: Wed, 26 Aug 2009 12:51:38 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: uwb tree build failure
References: <20090826171054.631ad39c.sfr@canb.auug.org.au>
In-Reply-To: <20090826171054.631ad39c.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Aug 2009 11:51:37.0918 (UTC) FILETIME=[917F3DE0:01CA2643]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi David,
> 
> Today's linux-next build (powerpc allyesconfig) failed like this:
> 
> drivers/uwb/reset.c: In function 'uwbd_msg_handle_reset':
> drivers/uwb/reset.c:334: error: implicit declaration of function 'msleep'
> 
> Caused by commit ffefcfffee9deb283ab278b0e142807cf0c18d61 ("uwb: avoid
> radio controller reset loops") from the uwb tree.

Should be fixed now.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


'member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom'
