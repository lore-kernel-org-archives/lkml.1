Return-Path: <linux-kernel-owner+w=401wt.eu-S965634AbXAXDsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965634AbXAXDsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 22:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965638AbXAXDsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 22:48:17 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:16793 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965634AbXAXDsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 22:48:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=RKkj+leD4rbGNNPygkorhBD/2VOa3208/ODxyDjhIp0YlPWcqGFF/VgIAQSVWj0FBHA7O1fzpBfwoHWii1+vpuY4kivwh4Oaa6HzMXrvhRCNZPjL6SDfC703gbga5G5c75S2xvvj/RmYShWtxTTNz81ofR/W4HdpNmQ5F80aavw=
Message-ID: <59ad55d30701231948u5f1e02d8x3d06553cb373e5be@mail.gmail.com>
Date: Tue, 23 Jan 2007 22:48:15 -0500
From: "=?UTF-8?Q?Kristian_H=C3=B8gsberg?=" <krh@bitplanet.net>
To: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: In-tree version of new FireWire drivers available
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: c07864a69ae7c00d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've moved the new FireWire stack to an in-tree git repository and
moved over the missing patches from my out-of-tree version.  The tree
is available over here:

  git://people.freedesktop.org/~krh/linux-2.6

with gitweb avialable here:

  http://gitweb.freedesktop.org/?p=users/krh/linux-2.6.git;a=summary

There's only one branch there which is branched of off Stefan Richters
master from the linux1394 repo, and has the most recent work from my
out-of -tree repo.  Hosting this on freedesktop.org should be fine,
though kernel.org may be more appropriate :)

Changes since the merge into the linux1394 tree include:

 - gap count optimization
 - full bus management
 - loopback for async requests to the local node
 - a bug fix for a problem exposed by VIA 6306 controllers
 - a typo fix from the bitfield -> mask+shift conversion.

Plus I've merged Stefans recent fixes and resolved the few conflicts
from that.  Stefan, I'm still not sure what the work flow should be
here, do you want to just pull these changes or should I send the 13
patches to linux1394-devel?

cheers,
Kristian
