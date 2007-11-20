Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbXKTVrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbXKTVrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbXKTVrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:47:12 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:32256 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbXKTVrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:47:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ErrdPI13Frwp7ocQ48xagYvGcl9bT3pT57rCRt6M9+agLhphjByHlRaRp4Vy1Us+VVlO/vA07EVlrhjIu7wk4HnxeLboMPw6y5uAnsdDHsli0w5mDl8AlUJ+bShbpe8v6MV9Bb2qNjxsYcYDd5n8H4aXoF8A8rWpkJ5ycG2ZEK0=
Message-ID: <d9def9db0711201347u2786fe0ev96b2fb43fc2954e9@mail.gmail.com>
Date: Tue, 20 Nov 2007 22:47:09 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       "Laurent Pinchart" <laurentp@cse-semaphore.com>
Subject: USB deadlock after resume
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm looking at the linux uvc driver, and noticed after resuming my
notebook it deadlocks at usb_set_interface.
The linux kernel version on that notebook is 2.6.21.4, I searched
around and haven't found any such bugreports.
I wonder if anyone has ever heard about such a problem?

I'm digging closer into that issue now..

thanks,
Markus
