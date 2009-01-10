Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbZAJLbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbZAJLbM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 06:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZAJLa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 06:30:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:15057 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbZAJLa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 06:30:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=jB7zABhii4QQP0jeTFp0/F5Wk+q3Hw/DqmbwPOWx7ocaVPeVRryIbPkVoxAbcayhxr
         UIXFR6pK69Clq6O+rkQW89ny+KpAfKcuR3kJQDhHy9dZiImr5DiEeiHgCUYDWuNU6O9l
         +8G5xd8XSXj1a0s/w/fcsmbGPjNjgNI2Jfh9U=
Date: Sat, 10 Jan 2009 14:28:12 +0300
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Network device with variable hard header len
Message-ID: <20090110112812.GA8393@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry if this a dumb question. Currently I'm programming a driver for
the devices with variable network header len. From the Linux net stack
perspective what should I do: set netdev->hard_header_len to maximum
possible header and use less space that specified there or set
netdev->needed_headroom to that value?

If that metters, I'll be implementing my own set of header_ops in any
case.

Thank you

-- 
With best wishes
Dmitry

