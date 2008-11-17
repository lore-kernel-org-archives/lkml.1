Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbYKQUnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbYKQUnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYKQUnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:43:10 -0500
Received: from igw2.watson.ibm.com ([129.34.20.6]:54666 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbYKQUnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:43:09 -0500
Subject: Re: [PATCH 0/4] integrity
From: david safford <safford@watson.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       jmorris@namei.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       serue@linux.vnet.ibm.com
In-Reply-To: <20081114141813.71a0050a.akpm@linux-foundation.org>
References: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
	 <20081114141813.71a0050a.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 17 Nov 2008 15:42:37 -0500
Message-Id: <1226954557.3080.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 14:18 -0800, Andrew Morton wrote:
> On Wed, 12 Nov 2008 22:47:10 -0500
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > The Linux Integrity Module (LIM) Framework provides hooks
> > ...
> This all looks quite mergeable to me, although I am far from being an
> expert on security things.
> 
> One thing which I cannot say, and which is quite important: how useful
> will all of this be to our users?  Are people asking for it?  Are
> people likely to enable and use it?  Are they even likely to understand
> it?  ;) Are any large/important customers asking for it?  Are distros
> likely to enable and support it?

LIM/IMA's maintenance of a TPM hardware anchored file measurement 
list is fundamental to the Trusted Computing Group's standards 
efforts. Several projects have implemented the TNC (Trusted Network
Connect) and PTS (Platform Trust Services) standards (see below). 
There are three demo packaged distros which have integrated these
apps, two of which are government funded (EU and US), with definite
customer interest. We are working with the RHEL team to provide
a supported, patched kernel for HAP. All of these so far have used
the old LSM based IMA, and have asked for a supported, upstreamed 
implementation, with the ability to work with SELinux.

Standards
http://www.trustedcomputinggroup.org

TNC/PTS Projects:
http://tnc.inform.fh-hannover.de/wiki/index.php/Main_Page  (server)
http://sourceforge.net/projects/libtnc   (library)
http://hostap.epitest.fi/wpa_supplicant/wpa_supplicant   (client)
http://sourceforge.jp/projects/openpts   (client and server)

Test Distros:
http://unit.aist.go.jp/itri/knoppix/index-en.html   (trusted Knoppix)
http://www.nsa.gov/ia/industry/HAP/   (US)
http://www.opentc.net   (EU)






