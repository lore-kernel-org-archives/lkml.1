Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142Ab0AWAOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab0AWAOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104Ab0AWAOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:14:33 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:55047 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0AWAOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:14:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i407IPIiE3qlrs7rAxggK1SidEgtzGTkPmtp7w3MrBXu8mfoxpALVGhy82MKe0P3o7
         cCF/yf7K8Qm1k881hB39ehz/MO0uf0XT9Z+DMKRyFnEdhXLiHeHo1DiB+Z9APuuwxq9o
         ID4E1n0CP9GQW2T/8wYmt1x/Zm2Vux/1Toqco=
Date: Fri, 22 Jan 2010 16:14:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       "Frysinger, Michael" <Michael.Frysinger@analog.com>,
       "Getz, Robin" <Robin.Getz@analog.com>,
       Jean Delvare <khali@linux-fr.org>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [RFC] Staging:IIO: New ABI
Message-ID: <20100123001414.GB14538@core.coreip.homeip.net>
References: <4B571DA4.6070603@cam.ac.uk>
 <20100120153748.GA29401@kroah.com>
 <4B573501.9090001@jic23.retrosnub.co.uk>
 <20100122204718.GA15759@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100122204718.GA15759@kroah.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 12:47:18PM -0800, Greg KH wrote:
> On Wed, Jan 20, 2010 at 04:53:21PM +0000, Jonathan Cameron wrote:
> > I am not aware of these. Could you direct me to the current api? Also note that these
> > aren't the actual alarms, merely a means of enabling the relevant event on the related
> > event character device. 
> 
> Hm, I thought we had an accelerator interface somewhere...
> 

Nope. And I am also interested in this since I am sittign on a bunch of
accelerometers, magnetometers, etc drivers that are trying to plug into
input sysbsystem and quite unsure what to do with them.

It was OK whch HDAPS and friends when they were using input for
secondary, toyish purposes, but these new drivers trying to use input
devnts as primary API and I am unsure if it is the best solution.
Accelerometer might be used as an input device but not always an input
device.

-- 
Dmitry
