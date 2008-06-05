Return-Path: <linux-kernel-owner+w=401wt.eu-S1757757AbYFEN6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757AbYFEN6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 09:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbYFEN6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 09:58:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:17615 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbYFEN6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 09:58:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=w/t7l41lIpFK0EMKHrxxeLNVdqWdlB468t1USE54qzQi1YpBqZtf0r8C89pQYEbSdy
         OcD5yOo6YJu71+oUNME0iLiCiecAFaqaqfq5C3DboaVB9a0UvbVXlDQvVtqHhmUsAucH
         zhN5zy1VlOJQb/gTDx+jv0AADXNyGmq/Em6PM=
Message-ID: <e2e108260806050658r3fb8b3b2gaf486c2647271e69@mail.gmail.com>
Date: Thu, 5 Jun 2008 15:58:00 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: Re: Strange mptbase / mptscsih kernel messages
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>,
       linux-scsi@vger.kernel.org
In-Reply-To: <5AE055B67BB5764693E2900C7E3699BE0110FAEB@pamail.ad.lsil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5AE055B67BB5764693E2900C7E3699BE0110FAEB@pamail.ad.lsil.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2008 at 10:33 AM, Prakash, Sathya <Sathya.Prakash@lsi.com> wrote:
> The meaning of 1 message is some fram transmit error encountered by
> hardware and the I/O request is aborted by firmware because of the
> error,
> The second message indicates, some I/O got timed out and the SML tries
> to abort the request and the firmware completes the I/O before aborting
> that. Hence returns IO executed message and the driver completes the
> abort as success.
> Suspecting some bad hardware in the topology(cables?)

Hello Sathya,

It took some time before I could have a closer look at the system on
which I observed the strange kernel messages. Apparently the RAID
controller (LSISAS3081E ?) is not connected directly to the 16 disks
but via a SAS expander (Super Micro SC836 SAS Backplane with two LSI
SASX28 Expander Chips --
http://www.supermicro.com/products/chassis/3U/836/SC836E2-R800.cfm).
It will be a challenge to find out which component triggered the
kernel messages and how to make the storage subsystem work perfectly.
Any hint is welcome.

Bart.
