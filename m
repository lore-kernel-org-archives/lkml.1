Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbYJYItU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbYJYItU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 04:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbYJYItM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 04:49:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:44320 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYJYItL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 04:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=wimUn/+08J2La5RzxBNgtmmKlb3jhHO2FfYtTInw7ymMwHivnRBWcIuhFIzHMnJEhM
         GvxOGpZhsIKGtIU9hG2+KpY5EKgD4fB3EB/j8g/fu3901/axiyGmX31Ms3ZjNUo8/jKw
         RXtYvpV3OIC8HwJHmfYLxhRYw9z2AL08KEmhI=
Message-ID: <4902DD98.4090302@gmail.com>
Date: Sat, 25 Oct 2008 01:49:28 -0700
From: Rob MacKinnon <c4blem0nkey@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080904)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: tmpfs support of xattrs?
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The background: So during the initial configuration of a box I enabled
the xattr flags for ext3 and options of xattr in coreutils, and at the
time didn't realize that I'd hit a snag that would finally annoy me
enough after a month of getting a non-fatal error messages from cp "cp:
listing attributes of `/dev/null`: Invalid argument" to spend half a day
researching the cause and a potential solution.

Setup: udev mounts a tmpfs to /dev then fills it with device nodes.
Problem: the resulting tmpfs has no xattr support.
Therefore: Tmpfs without xattrs, and coreutils  and everywhere else with
xattr support, cp freaks.

Is there sometime in the forseable future when the tmpfs module will
support for xattrs in the stable branch, or should I "holler at the
maintainers of coreutils to fix their broken code in cp". Even better
(and I like this option the most) a little of both?

-- Rob
