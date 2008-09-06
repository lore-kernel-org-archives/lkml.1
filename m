Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbYIFJZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbYIFJZy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 05:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYIFJZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 05:25:47 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:4770 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYIFJZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 05:25:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iV5DP47AOxajimVFp2VX+KnI9EwV2VKCFEfSR/KsZkH8Wlenl3caZh0mYHmdGXccLI
         UMW2pQIJSIdAjB1PodRZEZxOiEI+kIYUPncGURWbaOa1+6v7mdNnMF9Mi9cweboRNRMD
         HxLYC8wjkzc4a2WHC9VizNg6iKTu33rkNJFaY=
Message-ID: <8ee0b8e80809060225w585f7162v4833daf1fd2fe71@mail.gmail.com>
Date: Sat, 6 Sep 2008 11:25:44 +0200
From: "Jeroen van Rijn" <jvrnix@gmail.com>
To: "James Courtier-Dutton" <James@superbug.co.uk>
Subject: Re: Uniquely identify and Motherboard Model.
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48C248B9.6010805@superbug.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48C248B9.6010805@superbug.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2008 at 11:09 AM, James Courtier-Dutton
<James@superbug.co.uk> wrote:
> Hi,
>
> Is there a way I could uniquely identify a Motherboard Model. I don't
> need the serial number, just the model.

Doesn't dmidecode already allow this?
e.g. sudo dmidecode --type baseboard
possibly combined with: sudo dmidecode --type chassis

See for reference:
http://www.cyberciti.biz/tips/querying-dumping-bios-from-linux-command-prompt.html

> Applications for this could be:
> 2) Sound card in/out wiring.

With respect to sound in/out, it might benefit userland as well, to
help set up your speakers. Particularly as some cards allow for
several plugs to be both in- and output at one's choosing.
