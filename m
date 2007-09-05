Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbXIEQuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbXIEQuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbXIEQtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:49:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:18299 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbXIEQtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:49:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=KNLl1C3lkCo7WBueM5QvLZuq/eQ8jXUGNdmtx2N9mJBIVxcx5wWr7/pszzYlMK7Wt5g1TsrepbEYkLqivVR9fXNwULApNxkN4oC0EYWjirLXKXasq2aAXLcDDnIBhm2o7asJ7i/bSNqY2jCOTLDKN/mF/50TKlmwI1du+6Sj1bw=
Message-ID: <46DE89C9.7060403@gmail.com>
Date: Wed, 05 Sep 2007 04:49:45 -0600
From: Sean Robert McGuffee <sean.mcguffee@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Bug Report Requested
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Something popped up and told me to send this information as a bug report 
even though it didn't have a button to click to do that automatically 
which is a bug in itself I think:

Component: pirut
Summary: TB253c984a 
depsolve.py:574:_requiringFromTransaction:IndexError: list index out of 
range

Traceback (most recent call last):
  File "/usr/sbin/pup", line 409, in _apply
    self.applyChanges(self.mainwin)
  File "/usr/lib/python2.5/site-packages/pirut/__init__.py", line 734, 
in applyChanges
    self.checkDeps(mainwin)
  File "/usr/lib/python2.5/site-packages/pirut/__init__.py", line 493, 
in checkDeps
    (result, msgs) = self.buildTransaction()
  File "/usr/lib/python2.5/site-packages/yum/__init__.py", line 540, in 
buildTransaction
    (rescode, restring) = self.resolveDeps()
  File "/usr/lib/python2.5/site-packages/yum/depsolve.py", line 885, in 
resolveDeps
    (checkdep, missing, conflict, errormsgs) = self._processReq(dep, 
prcoformat_need)
  File "/usr/lib/python2.5/site-packages/yum/depsolve.py", line 334, in 
_processReq
    requirementTuple, errormsgs)
  File "/usr/lib/python2.5/site-packages/yum/depsolve.py", line 469, in 
_requiringFromInstalled
    return self._requiringFromTransaction(reqpkg, requirement, errorlist)
  File "/usr/lib/python2.5/site-packages/yum/depsolve.py", line 574, in 
_requiringFromTransaction
    reqpkg = self.tsInfo.matchNaevr(name=name, ver=version, rel=release)[0]
IndexError: list index out of range

Local variables in innermost frame:
requirement: ('perl(DCOP)', 0, '')
checkdeps: 0
needname: perl(DCOP)
pkg: kdebindings-dcopperl - 3.5.7-1.fc7.1.x86_64
missingdep: 0
self: <__main__.PackageUpdater object at 0xfaeb50>
tspkgs: []
dbpkgs: []
version: 3.5.7
msg: Potential resolving package kdebindings - 3.5.6-1.fc7.x86_64 has 
newer instance installed.
needflags: 0
needversion:
dbpkg: kdebindings - 3.5.7-1.fc7.1.x86_64
errorlist: []
pkgmode: None
a: x86_64
e: 0
name: kdesdk
n: kdebindings-dcopperl
r: 1.fc7.1
v: 3.5.7
release: 7.fc7
requiringPkg: ('kdesdk', '3.5.7', '7.fc7', None)
tsState: None
provSack: <yum.packageSack.ListPackageSack object at 0x9c0be50>

