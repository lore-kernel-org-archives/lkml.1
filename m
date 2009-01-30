Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbZA3WFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbZA3WFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbZA3WFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:05:39 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:54186 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZA3WFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:05:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=RxfrCnrURkMYWXaWqsBBHdz40RrpUKOx2aeKULAY4YjR6LX9gzCm51332URG9MHsrM
         37eVL242XI6op6hRZt0AYUzelK1YgilVBj0y+hlmirPsVzr9jRcrZsdoKwAqaV6U0qIi
         Y66gQVGFIGny6x9VKRjM8wR6lQlv44Pq/nqlU=
MIME-Version: 1.0
Date: Fri, 30 Jan 2009 14:05:36 -0800
Message-ID: <23986fd90901301405r462563c1o5a28e18f4dd63e34@mail.gmail.com>
Subject: Fibre Channel without SCSI?
From: "Patrick J. LoPresti" <lopresti@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am interested in experimenting with Fibre Channel at a low level
(layer FC-2), preferably using off-the-shelf hardware.

But as near as I can tell browsing the Linux source, Fibre Channel and
SCSI seem to be joined at the hip.

Questions:

- Is there a user-space interface to access the raw Fibre Channel
protocol via an ordinary HBA?

- If not, are the kernel internals such that doing this from kernel
space would be relatively straightorward?

- Or is this just a bad idea?

Again, my goal is to bypass the SCSI protocol entirely.  Put another
way, I want to implement my own upper-level protocol on top of FC-2,
but without having to re-write an entire HBA driver.

Any pointers (however brief) or redirection to a more appropriate
forum would be appreciated.

Thank you!

 - Pat
