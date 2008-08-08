Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbYHHTgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbYHHTgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbYHHTgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:36:08 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48931 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbYHHTgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:36:07 -0400
In-Reply-To: <20080808190448.GA3356@kroah.com>
References: <20080808184349.999902616@linux.vnet.ibm.com> <1218221742.4444.12.camel@localhost.localdomain> <20080808190448.GA3356@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       linux-security-module-owner@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       sailer@watson.ibm.com, Stephen Smalley <sds@tycho.nsa.gov>,
       serue@linux.vnet.ibm.com, Al Viro <viro@ZenIV.linux.org.uk>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] integrity: special fs magic
X-KeepSent: FAAF261A:9C9A337A-8525749F:0069FF16;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.0.1 February 07, 2008
Message-ID: <OFFAAF261A.9C9A337A-ON8525749F.0069FF16-8525749F.006BAB9C@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Fri, 8 Aug 2008 15:36:15 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V85_M1_05262008|May 26, 2008) at
 08/08/2008 15:36:03,
	Serialize complete at 08/08/2008 15:36:03
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-security-module-owner@vger.kernel.org wrote on 08/08/2008 03:04:48 
PM:


> Re: [PATCH 2/4] integrity: special fs magic
> 
> On Fri, Aug 08, 2008 at 02:55:42PM -0400, Mimi Zohar wrote:
> >     - Move special fs magic number definitions to magic.h
> >     - Add magic.h include
> > 
> >     Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> 
> Why?  What is this patch for?  Are you going to do something with these
> magic values later?
> 
> thanks,
> 

yes, [PATCH 4/4] integrity: IMA as an integrity service provider,
uses these definition in defining the default IMA measurement policy.
The default policy can be replaced with an LSM specific one.  More
details on the IMA measurement policy are available in 
Documentation/ABI/testing/ima_policy.

Mimi



