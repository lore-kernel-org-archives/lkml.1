Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZFTJyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZFTJyn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 05:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZFTJye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 05:54:34 -0400
Received: from mail-pz0-f195.google.com ([209.85.222.195]:64119 "EHLO
	mail-pz0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZFTJyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 05:54:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=koOmtuXB8FPGa/asaNYxIVpTp9NVerJTmLIHmxDSKr+JrbEorpkESu0tLC9OLQ0bMW
         NaqfF5De5+cFQx4UtE7xoFdHKawmKFo8dBI1uHqDOzf7ezYQ7lAFR1xFz3UGJ2iEy5YS
         DswWNixt3u5fRTCv38aeFqiHgw5ImFUHq6wGw=
MIME-Version: 1.0
In-Reply-To: <e31d15d70906200252g300fda01rf227f54259c33b7c@mail.gmail.com>
References: <e31d15d70906200252g300fda01rf227f54259c33b7c@mail.gmail.com>
Date: Sat, 20 Jun 2009 15:24:36 +0530
Message-ID: <e31d15d70906200254m3ab04065y3f4b853d0de72471@mail.gmail.com>
Subject: Re: Packet Overrun for traffic over 1 Gbps
From: Deepak Vishwakarma <vishwakarma.deepak@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a high end server machine(multi core and large memory space)
with 10 Gbps NIC. With linux kernel 2.6.18 it is giving packet overrun
as traffic goes beyond 1.5 Gbps. I need suggestions in tuning kernel
so that it can handle higher traffic rates.

I have a 10 Gbps test bed to test the capability of server, equipped
with 10Gig switch and traffic is generated from many 1Gig machines. I
have tested server machine by gradually increasing the incoming
traffic rate and it's starting to do packet overrun as it crosses 1
Gbps.

The 10 Gig NIC is from broadcom,  (netxtreme). I have tested NIC with
the driver shipped by vendor that is bnx2x v 1.44 and latest available
on net, both are giving more or less same result. Will it help to try
latest kernel 2.6.30 ? or what could be other possible tuning in
kernel to make it handle high traffic (3-4 Gbps).

Thanks and regards,
Deepak
