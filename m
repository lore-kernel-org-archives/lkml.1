Return-Path: <linux-kernel-owner+w=401wt.eu-S934814AbZKYRr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934814AbZKYRr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932232AbZKYRrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:47:53 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56979 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973AbZKYRq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:46:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=UiZbtfjhvN8p3pTIjcRcqQEx8xS5XmTrkbw/xB1gFRWlyRt2kg2uGQ7rm+1/kWQvym
         je+RfB1Hdlp+ZUBs02ew2g1aAx1OeX0smOfOvHGWBuH1g/APyXtFsEu5pQ/1B51DPB00
         D7yfmlP3wIWZvofsk5t5eAPqGjwJVPkq46j3s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 19/86] pata_cmd640: document known issues
Date: Wed, 25 Nov 2009 18:34:04 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125170436.5446.83994.sendpatchset@localhost> <20091125172633.7a15711b@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125172633.7a15711b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911251834.04189.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009 06:26:33 pm Alan Cox wrote:
> On Wed, 25 Nov 2009 18:04:36 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] pata_cmd640: document known issues
> > 
> > Document known issues with the driver to aid distribution makers,
> > users and developers in making informed decisions instead of wasting
> > their time needlessly.
> 
> Umm. its a) under CONFIG_PCI, and b) says CMD640 PCI IDE...

c)

 *      This drives only the PCI version of the controller. If you have a
 *      VLB one then we have enough docs to support it but you can write
 *      your own code.

Then what has happened to CMD640 VLB IDE support in libata?

--
Bartlomiej Zolnierkiewicz
