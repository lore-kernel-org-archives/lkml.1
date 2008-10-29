Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbYJ2FZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbYJ2FZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 01:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYJ2FYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 01:24:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:62508 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbYJ2FYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 01:24:15 -0400
Message-ID: <9ae48b020810282224x31706492mdbaae102909ba63b@mail.gmail.com>
Date: Tue, 28 Oct 2008 22:24:14 -0700
From: "Ed Swierk" <eswierk@aristanetworks.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix range check on mmaped sysfs resource files
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_69510_16016096.1225257854392"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_69510_16016096.1225257854392
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

pci_mmap_fits() in 2.6.27.4 returns the wrong answer if the sysfs
resource file size is not a multiple of the page size. vm_end and
vm_start are already page-aligned, so size - start < nr, causing
mmap() to return EINVAL.

Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>

------=_Part_69510_16016096.1225257854392
Content-Type: application/octet-stream;
 name=linux-2.6.27-pci-sysfs-mmap-bug.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fmviqei40
Content-Disposition: attachment;
 filename=linux-2.6.27-pci-sysfs-mmap-bug.patch

SW5kZXg6IGxpbnV4LTIuNi4yNy40L2RyaXZlcnMvcGNpL3BjaS1zeXNmcy5jCj09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0K
LS0tIGxpbnV4LTIuNi4yNy40Lm9yaWcvZHJpdmVycy9wY2kvcGNpLXN5c2ZzLmMKKysrIGxpbnV4
LTIuNi4yNy40L2RyaXZlcnMvcGNpL3BjaS1zeXNmcy5jCkBAIC00OTIsNyArNDkyLDcgQEAgc3Rh
dGljIGludCBwY2lfbW1hcF9maXRzKHN0cnVjdCBwY2lfZGV2IAogCiAJbnIgPSAodm1hLT52bV9l
bmQgLSB2bWEtPnZtX3N0YXJ0KSA+PiBQQUdFX1NISUZUOwogCXN0YXJ0ID0gdm1hLT52bV9wZ29m
ZjsKLQlzaXplID0gcGNpX3Jlc291cmNlX2xlbihwZGV2LCByZXNubykgPj4gUEFHRV9TSElGVDsK
KwlzaXplID0gKChwY2lfcmVzb3VyY2VfbGVuKHBkZXYsIHJlc25vKSAtIDEpID4+IFBBR0VfU0hJ
RlQpICsgMTsKIAlpZiAoc3RhcnQgPCBzaXplICYmIHNpemUgLSBzdGFydCA+PSBucikKIAkJcmV0
dXJuIDE7CiAJV0FSTigxLCAicHJvY2VzcyBcIiVzXCIgdHJpZWQgdG8gbWFwIDB4JTA4bHgtMHgl
MDhseCBvbiAlcyBCQVIgJWQgKHNpemUgMHglMDhseClcbiIsCg==
------=_Part_69510_16016096.1225257854392--
