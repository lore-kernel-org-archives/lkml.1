Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbZBLCEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbZBLCEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 21:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbZBLCEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 21:04:22 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:47681 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753099AbZBLCEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 21:04:21 -0500
Subject: [Announce] Cpuset (cset) v. 1.5.0 available
From: Alex Tsariounov <alext@novell.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 19:04:13 -0700
Message-Id: <1234404253.5483.27.camel@zuul>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings:

We are pleased to announce the immediate availability of cpuset (cset)
v1.5.0 from here:

 Source:   http://developer.novell.com/wiki/index.php/Cpuset
 Packages: http://download.opensuse.org/repositories/home:/tsariounov:/cpuset/

Cpuset is a GPL v2 Python application to make using the cpusets
facilities in the Linux kernel easier. It allows manipulation of cpusets
on the system and provides higher level functions such as implementation
and control of a basic CPU shielding setup.  The actual command is
called cset.

If you're tired of manipulating cpusets by hand, or writing and
rewriting cpuset startup scripts to help manage shielding, then this
tool could be for you.

The source link above contains access to a subversion repository,
bugzilla instance and mailing lists for cpuset.

For an more in-depth writeup on cpuset, see the RT wiki at:
http://rt.wiki.kernel.org/index.php/Cpuset_management_utility

Which also includes the new tutorial:
http://rt.wiki.kernel.org/index.php/Cpuset_management_utility/tutorial

Thanks,
Alex Tsariounov


Changes from 1.04 -> 1.5.0 as follows:
============================================================
Cpuset 1.5.0 (February 7, 2009)
https://forgesvn1.novell.com/svn/cpuset/tags/rel_1.5.0
http://download.opensuse.org/repositories/home:/tsariounov:/cpuset/

Major upgrade since 1.04.  This release includes a number of bug fixes and
enhancements as outlined below.  The release number also has transitioned to a
three-digit number.  This release has many usability enhancements from the
past months experience.  It also includes a lengthy tutorial to introduce
users to the tool.

The bug numbers refer to cpuset's bugzilla instance which can be found
here:  http://devzilla.novell.com/cpuset

Fixed Bugs:
* Fix bug #1: Origination cpuset not accepted for process move...
* Fix bug #2: Proc move from set to set does not recognize...
* Fix bug #3: Interspersed arguments do not work
* Fix bug #4: Add policy and priority to proc output list
* Fix bug #5: Add ability to move all threads in a process container wi.
* Fix bug #6: The -a option for set listing should be the default
* Fix bug #7: Add destination cpuset for the proc move command
* Fix bug #8: Let leading slash for nested cpuset spec be optional
* Fix bug #9: Rearrange info output some, include machine readable output
* Fix bug #10: Add a recursive cpuset delete with option
* Fix bug #11: Add a configuration file
* Fix bug #12: Add hex mask output for cpuset definition spec (cpuspec)
* Fix bug #13: Add cpuset rename option to set command
* Fix bug #21: Create shield shortcuts

Other fixes:
* Changed behavior of shield command, now it behaves more like the proc move
  command: -s or -u needs a -p to shield or unshield, however, the shortcut of
  shield pidspec still works.
* Fixed exception when using cset with pipes
* Fixed set list behavior if --set was specified but not --list
* Added error message if proc list command does not specify a set
* Fixed exception if proc is used with -l and -s
* Location for cpuset filesystem mount can be specified in config file
* Changed proc option -a/--all to --force only
* Updated copyrights, URLs and documentation
* Added spec file to svn which is used in build service
* Cleaned up status output for clarity and consistency
* Additional minor corner case bug fixes included
============================================================


