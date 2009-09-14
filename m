Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZINLWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZINLWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 07:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbZINLWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 07:22:05 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:40120 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbZINLWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 07:22:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=WAPzMxoFXAnJ2+SRy0iRK7zNuP8AmO5EvDfugQKj4x0547/ZqH+/P71lqveiuImsI8
         Yx5Pm8t+0GJ4dRwJAW3Bz+utH/QZVbYCApedb+MOUMlaTxNRWSUkgOaMRScZlvxjQRIQ
         9qKZ2UKEjuG7or+SGbpZq2l1BQsQFqvsBMHwI=
MIME-Version: 1.0
Date: Mon, 14 Sep 2009 13:22:05 +0200
X-Google-Sender-Auth: da5168da48205596
Message-ID: <98bb29450909140422q31b61637q54573ad471bc059a@mail.gmail.com>
Subject: Patch for Documentation/filesystems/proc.txt
From: Luis Garces-Erice <lge@ieee.org>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001485f1bdb229c967047387e032
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001485f1bdb229c967047387e032
Content-Type: text/plain; charset=ISO-8859-1

Hi

the description in Documentation/filesystems/proc.txt of the
procs_running entry in /proc/stat is confusing (according to that
description, it looks as if procs_running could only be a number
between 0 and the number of CPUs).

Changed it to a more accurate description in the patch attached.

Cheers,

-- 
Luis
****

--001485f1bdb229c967047387e032
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fzl4k90w0

LS0tIGxpbnV4LTIuNi4zMS9Eb2N1bWVudGF0aW9uL2ZpbGVzeXN0ZW1zL3Byb2MudHh0Lm9yaWcJ
MjAwOS0wOS0xNCAxMjo0OTowNC4wMDAwMDAwMDAgKzAyMDAKKysrIGxpbnV4LTIuNi4zMS9Eb2N1
bWVudGF0aW9uL2ZpbGVzeXN0ZW1zL3Byb2MudHh0CTIwMDktMDktMTQgMTI6NTM6MjUuMDAwMDAw
MDAwICswMjAwCkBAIC0xMDcxLDggKzEwNzEsOCBAQCBUaGUgInByb2Nlc3NlcyIgbGluZSBnaXZl
cyB0aGUgbnVtYmVyICBvCiBpbmNsdWRlcyAoYnV0ICBpcyBub3QgbGltaXRlZCAgdG8pIHRob3Nl
ICBjcmVhdGVkIGJ5ICBjYWxscyB0byB0aGUgIGZvcmsoKSBhbmQKIGNsb25lKCkgc3lzdGVtIGNh
bGxzLgogCi1UaGUgICJwcm9jc19ydW5uaW5nIiBsaW5lIGdpdmVzIHRoZSAgbnVtYmVyIG9mIHBy
b2Nlc3NlcyAgY3VycmVudGx5IHJ1bm5pbmcgb24KLUNQVXMuCitUaGUgInByb2NzX3J1bm5pbmci
IGxpbmUgZ2l2ZXMgdGhlIHRvdGFsIG51bWJlciBvZiB0aHJlYWRzIHRoYXQgYXJlCitydW5uaW5n
IG9yIHJlYWR5IHRvIHJ1biAoaS5lLiwgdGhlIHRvdGFsIG51bWJlciBvZiBydW5uYWJsZSB0aHJl
YWRzKS4KIAogVGhlICAgInByb2NzX2Jsb2NrZWQiIGxpbmUgZ2l2ZXMgIHRoZSAgbnVtYmVyIG9m
ICBwcm9jZXNzZXMgY3VycmVudGx5IGJsb2NrZWQsCiB3YWl0aW5nIGZvciBJL08gdG8gY29tcGxl
dGUuCg==
--001485f1bdb229c967047387e032--
