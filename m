Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbXHAVLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbXHAVLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbXHAVLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:11:12 -0400
Received: from web52901.mail.re2.yahoo.com ([206.190.49.11]:47699 "HELO
	web52901.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751529AbXHAVLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:11:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=HU5bGMiQbL5oyCcWzv/UepMNejUMP1J4W6eeluQCWh14tDOYCwn/RNnn920NXckpkMynOUjI2SQY2eUuYwDxwrTtRSj2JLZvFe5IjIHJhQRji3AImdUbhLsibH4G7FLN6jaPZX4gwYeOEpuSxRGWx9uCXaf/OQcAN/xpqGGaZf0=;
X-YMail-OSG: BXYCKhcVM1lB4ya9TA2hY4qm7LRnjtafO0YAHG40UO8DwF3aWaqnWbRCGvPHYErQeg--
Date: Wed, 1 Aug 2007 22:11:09 +0100 (BST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [BUG] Linux 2.6.22 - Atomic counter underflow in NFS
To: Satyam Sharma <satyam@infradead.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.999.0708020237090.8258@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <699754.45152.qm@web52901.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Satyam Sharma <satyam@infradead.org> wrote:
> I expect this is easy to reproduce at will (when shutting down nfs
> services, probably), right?

I'm not sure about the "at will" part because this is the first time I've seen it since 2.6.22 was
released. However, I was upgrading my Fedora 7 nfs-utils package at the time so it probably did
happen when the NFS service was being shut down.

> Please try the latest mainline -git kernel (say 2.6.23-rc1-git10 from
> kernel.org) and let us know if this still occurs? There were some fixes
> regarding sysfs symlink refcounting that went in recently, and this looks
> like one of those cases to me.

Do you have the actual patches instead?

Cheers,
Chris



      ___________________________________________________________
Yahoo! Answers - Got a question? Someone out there knows the answer. Try it
now.
http://uk.answers.yahoo.com/ 
