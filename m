Return-Path: <linux-kernel-owner+w=401wt.eu-S2992466AbXDRNde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992466AbXDRNde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 09:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992475AbXDRNde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 09:33:34 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:51376 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992469AbXDRNdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 09:33:32 -0400
Date: Wed, 18 Apr 2007 09:33:29 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: David Lang <david.lang@digitalinsight.com>
cc: Rob Meijer <capibara@xs4all.nl>, Karl MacMillan <kmacmill@redhat.com>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
In-Reply-To: <Pine.LNX.4.63.0704180001160.2442@qynat.qvtvafvgr.pbz>
Message-ID: <Line.LNX.4.64.0704180923260.25495@d.namei>
References: <20070416213350.GB4030@suse.de>    <Line.LNX.4.64.0704161846110.13905@d.namei>
    <1176846917.5946.79.camel@localhost.localdomain>
 <19259.213.222.28.155.1176880873.squirrel@webmail.xs4all.nl>
 <Pine.LNX.4.63.0704180001160.2442@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, David Lang wrote:

> SELinux is designed to be able to make the box safe against root, AA is
> designed to let the admin harden exposed apps without having to think about
> the other things on the system.

This is not correct.

SELinux was designed as an access control framework which allows various 
security models to be composed in a controlled and consistent manner, 
covering all security-relevant interactions in the system.

The type enforcement model included with it provides a means to address 
both integrity and confidentiality requirements.  It _can_ protect you 
against root, if that's what you want (in fact, the Russell Coker "play 
box" was online for many years with a published root password), but it 
does not have to.

Indeed, since Fedora Core 3, the default SELinux policy has been 
"targeted", which is aimed at confining exposed applications.



- James
-- 
James Morris
<jmorris@namei.org>
