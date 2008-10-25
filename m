Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbYJYI1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbYJYI1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 04:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYJYI1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 04:27:31 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:38602 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYJYI1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 04:27:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=AukghsLP1u+BWabV4gFib/npQWWzy85wwv4HvK3sUG37w56UwX/UjS17HkWPDPbhF6
         5ymfmEx5aPh0rrGUQ42RtvstmFhC07f6uidcd1hFsx1VEkKOOYjuVihb+Cy0d1k97jUM
         RJGoC/qF4XYf+oAiHEze0k34AwJ8uyND3EItw=
Message-ID: <4902D885.6050303@gmail.com>
Date: Sat, 25 Oct 2008 01:27:49 -0700
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

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

- -- Rob
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJJAtiFAAoJEPviweVbLO8VHFIP/jEDHs9aZb+mnR6RxwwOCASy
gYqqdiwzlnBezFVwiIE3pEK4f3jxsn7WJDWV64MqjtHB7POvguqGJPs7BBMsFVNq
Gs5Q/hkC1GSYp7+PkC28Ft8cg0ukm5o5hiwd0s7TW5g+bMK1/Xh4Rq4j8rRixzHG
Qnq/KyBlO77DKzLbBVZHMg6GWasvKc50w4bLGr134CKNnFb+EKSc3NJAMwuwKhZG
YUfn1LPhaF0jepGyr58cTnXcy0BrOkwUmKe9TsTytHuz3NjpXXhlMymj72U0C/Jo
ZD+olEVJshBXUfn3HrmXeL78YCQLheK56/YA3MbOSuwKjzPHn0BLkFvvhD7ks3Md
S2NrdJaJ+d9BafDRBCEbTqtR2xvka9JU3c1Oo5qS6O1BOWZY3QH9XN9s5526wqq1
r91F6D8EcrAFVly/FTDv57QXuRZ8hjddhFb8PuJMuVF3KD/zRp4/s4os4/INdVa8
CTDhomId6SftMPMAc3F/QquXN1EVd9FsMTL+81auegrv6HkiyWBf+lxhSIhSo2dk
3u6mGujpEezwSPVyQ0+5yxyEYHtW14ioVQtEOQPuk3Kp+IjSBo9b/HA+Y52Dv9V1
T6U6vtw/F4SbgvZ+vpSJPznu3f7DxhhtSBq4dAvsVn+a1h7fD2WgAh52TL/gQzxo
5yAlYi4DYSlMMJGPxEiZ
=Ezq7
-----END PGP SIGNATURE-----
