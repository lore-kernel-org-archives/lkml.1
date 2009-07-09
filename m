Return-Path: <linux-kernel-owner+w=401wt.eu-S1761130AbZGIOV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761130AbZGIOV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760924AbZGIOVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:21:18 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:50291 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760686AbZGIOVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:21:15 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jul 2009 10:21:15 EDT
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: jmorris@namei.org, gregkh@suse.de, sds@tycho.nsa.gov,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <4A554B95.6070709@schaufler-ca.com>
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <4A554B95.6070709@schaufler-ca.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 09 Jul 2009 10:11:52 -0400
Message-Id: <1247148712.4398.160.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 18:44 -0700, Casey Schaufler wrote:

> An LSM must not be beholden to exposing transient internal
> representations of security data to userspace, which is what
> you're doing here. An LSM gets to decide what the security
> information it maintains looks like by defining a security blob.

Something worth saying is that the sysfs_dirent is already a transient
internal represenation. 


