Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbZAWXLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbZAWXLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 18:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757741AbZAWXLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 18:11:36 -0500
Received: from anguilla.debian.or.at ([86.59.21.37]:33102 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757630AbZAWXLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 18:11:35 -0500
Date: Sat, 24 Jan 2009 00:11:33 +0100
From: Peter Palfrader <weasel@debian.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Florian Weimer <fw@deneb.enyo.de>, linux-kernel@vger.kernel.org,
       DSA <debian-admin@lists.debian.org>, team@security.debian.org,
       libpam-modules@packages.debian.org
Subject: Re: 2.6.28, rlimits, performance and debian etch
Message-ID: <20090123231133.GX2754@anguilla.noreply.org>
Mail-Followup-To: David Daney <ddaney@caviumnetworks.com>,
	Florian Weimer <fw@deneb.enyo.de>, linux-kernel@vger.kernel.org,
	DSA <debian-admin@lists.debian.org>, team@security.debian.org,
	libpam-modules@packages.debian.org
References: <20090121115219.GA2754@anguilla.noreply.org> <8763k5u3xs.fsf@mid.deneb.enyo.de> <497A3E62.6010706@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <497A3E62.6010706@caviumnetworks.com>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009, David Daney wrote:

> The real solution is to convert your user space programs to use the new 
> syscalls that allow for race-free setting of close-on-exec.  Then you no 
> longer need to mess around with iterating over these things.

It's python's popen2 implementation that does that for us. At least for
python2.4 and 2.5.

In our particular case moving away from calling external tools and doing
more within the scripts themselves brought a real speedup, but it's
probably not just us :)

-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
