Return-Path: <linux-kernel-owner+w=401wt.eu-S1761052AbXFTBep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761052AbXFTBep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 21:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757604AbXFTBei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 21:34:38 -0400
Received: from smtpout.mac.com ([17.250.248.172]:62835 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757578AbXFTBeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 21:34:37 -0400
In-Reply-To: <467868CF.30606@mnsu.edu>
References: <20070618212524.GC16393@cip.informatik.uni-erlangen.de> <Pine.LNX.4.64.0706181617060.18601@schroedinger.engr.sgi.com> <20070619061300.GK16393@cip.informatik.uni-erlangen.de> <Pine.LNX.4.64.0706191215570.7008@schroedinger.engr.sgi.com> <467868CF.30606@mnsu.edu>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <E92A0D0D-BC6B-48CB-A99B-875E9BE5A18B@mac.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Thomas Glanzmann <thomas@glanzmann.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: GIT Packages for Debian Etch
Date: Tue, 19 Jun 2007 21:33:48 -0400
To: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 19, 2007, at 19:37:51, Jeffrey Hundstad wrote:
> I'm just not going to let this go.  Stable is synonymous with, well  
> ummm, "stable."  That means that I don't have 3000 changes a month,  
> it's secure and the unexpected doesn't happen.  It means I can  
> write a lecture explaining how git works.  ...do updates... then  
> expect my lecture to still work the next day.  It means writing  
> local shell scripts and expecting them to work until the NEXT  
> stable release without changes.  It means knowing what things WILL  
> break if and when I do go to the next version.
>
> Stable is a CHOICE not a punishment.

With that said; Debian makes it easy to selectively install testing  
or unstable packages by adding "testing" or "unstable" to your  
sources.list and putting this in /etc/apt/apt.conf:
   APT::Default-Release "stable";

Then all apt-based programs will prefer stable packages everywhere  
possible.  If you explicitly run "apt-get install somepackage/ 
testing", then it will install the testing version of that package  
and continue to auto-upgrade it as testing receives updates.

Alternatively, you can "man apt_preferences" and tweak your "/etc/apt/ 
preferences" file to your heart's content.  This includes things like  
"Forcibly downgrade packages to the 'local' version if found in my  
local deb repo", "Prefer stable over testing and unstable", etc.

Cheers,
Kyle Moffett

