Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbYHQW11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbYHQW11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 18:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYHQW1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 18:27:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:60629 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYHQW1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 18:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=VIu1DzTLpRlfDO1R9MAtgaft1GHtnIIyMXZxM9m1dQm+QAntHcgw8wRfnM+VJ1eZbp
         sutF2I3O8svmg1iGx2TJlrzpTn2WUTvDgIr55sWr8UU+H+4Z4Os0JPVp1h+FrIa2Qp/O
         BJ/8TGXi8oahs0sVi4ZRGsZ+an/lr+FXIAsD4=
Message-ID: <30353c3d0808171527n6c4c6546iddf8f55253373508@mail.gmail.com>
Date: Sun, 17 Aug 2008 18:27:17 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: V4L2: switch to register_chrdev_region: needs testing/review of release() handling
Cc: "Hans de Goede" <j.w.r.degoede@hhs.nl>, v4l <video4linux-list@redhat.com>,
       "Laurent Pinchart" <laurent.pinchart@skynet.be>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, "Mike Isely" <isely@isely.net>
In-Reply-To: <200808172340.02280.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808171709.51258.hverkuil@xs4all.nl>
	 <200808172146.45683.hverkuil@xs4all.nl> <48A8981E.3060808@hhs.nl>
	 <200808172340.02280.hverkuil@xs4all.nl>
X-Google-Sender-Auth: 4acccd03a6559c85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like what you've done with this, it's very close to the patch I had
in mind. I especially like the way you hijacked cdev's kobj release..
I hadn't considered that. I would have sent you my version, but it was
based on the old videodev.c and needed to be redone after the videodev
split. The associated patch which moves cdev_del to video_release is
definitely the right thing to do. I don't know if it means much, but I
ACK this patch with the associated patch that moves cdev_del to
video_release.

ACKed by David Ellingsworth
