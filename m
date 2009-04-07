Return-Path: <linux-kernel-owner+w=401wt.eu-S1759971AbZDGTtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971AbZDGTtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756778AbZDGTsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:48:46 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:39991 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758861AbZDGTsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:48:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=KEh+EJKlJicG78uzaUQSrfu0ZeyibGu5gim3TiJWdYBnpxMpx88DCKVlytHpb/TsEk
         n3CCxkI1o1wEYUbcLPEwYLPwR2a1OUaKark93YlwUG6yccC775/C9BM5KRjVXbdRsMz2
         OXQxek0HjEZrbidZ8zOwaJdKK9ewGx1Y+WYqk=
MIME-Version: 1.0
Date: Wed, 8 Apr 2009 03:48:44 +0800
Message-ID: <b7997bdf0904071248t48fed168r7fa21b421c74358a@mail.gmail.com>
Subject: splice lost data
From: xinglp <xinglp@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd150b678bea00466fc4d0e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd150b678bea00466fc4d0e
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

2.6.29.1 in VM

When recv data more than 8K (1024*8) bytes at once, data lost happen.

--000e0cd150b678bea00466fc4d0e
Content-Type: text/plain; charset=US-ASCII; name="splice_test.c"
Content-Disposition: attachment; filename="splice_test.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ft904iks

I2RlZmluZSBTUExJQ0VfU0laRQkoMTAyNCo4KS8vd2hlbiBkZWZpbmUgU1BMSUNFX1NJWkUgYmln
Z2VyIHRoYW4gKDEwMjQqOCkgZGF0YSBsb3N0IGhhcHBlbi4NCi8vVGhpcyBmdW5jdGlvbiBpcyBj
YWxsZWQgd2hlbiBFUE9MTElOIG9uIFNvY2tldA0Kdm9pZCBSZWN2QnlTcGxpY2UoaW50IGhGaWxl
LGludCBTb2NrZXQpDQp7DQoJc3NpemVfdAlTaXplVG9SZWFkOw0KCXNzaXplX3QJU2l6ZVJlYWQ7
DQoJc3NpemVfdAlTaXplTGVmdDsNCglzc2l6ZV90CVNpemVXcml0ZTsNCg0KCXdoaWxlKENvbnRl
bnRMZW5ndGg+MCkvL0NvbnRlbnRMZW5ndGggaXMgZ2xvYmFsDQoJew0KCQlTaXplVG9SZWFkCT1T
UExJQ0VfU0laRT5Db250ZW50TGVuZ3RoP0NvbnRlbnRMZW5ndGg6U1BMSUNFX1NJWkU7DQoNCgkJ
U2l6ZVJlYWQJPXNwbGljZShTb2NrZXQsTlVMTCxQaXBlc1sxXSxOVUxMLFNpemVUb1JlYWQsU1BM
SUNFX0ZfTk9OQkxPQ0spOy8vUGlwZXNbXSBpcyBnbG9iYWwNCg0KCQlpZihTaXplUmVhZD4wKQ0K
CQl7DQoJCQlDb250ZW50TGVuZ3RoLT1TaXplUmVhZDsNCg0KCQkJU2l6ZUxlZnQ9U2l6ZVJlYWQ7
DQoJCQkNCgkJCXdoaWxlKFNpemVMZWZ0PjApDQoJCQl7DQoJCQkJU2l6ZVdyaXRlPXNwbGljZShQ
aXBlc1swXSxOVUxMLGhGaWxlLE5VTEwsU2l6ZUxlZnQsU1BMSUNFX0ZfTk9OQkxPQ0spOy8vUGlw
ZXNbXSBpcyBnbG9iYWwNCg0KCQkJCWlmKFNpemVXcml0ZT4wKQ0KCQkJCXsNCgkJCQkJU2l6ZUxl
ZnQtPVNpemVXcml0ZTsNCgkJCQl9DQoJCQkJZWxzZSBpZihFSU5UUj09ZXJybm8pDQoJCQkJew0K
CQkJCQljb250aW51ZTsNCgkJCQl9DQoJCQkJZWxzZQ0KCQkJCXsNCgkJCQkJcGVycm9yKCJzcGxp
Y2UiKTsNCgkJCQkJcmV0dXJuOw0KCQkJCX0NCgkJCX0NCg0KCQkJaWYoU2l6ZVJlYWQ8U2l6ZVRv
UmVhZCkNCgkJCXsNCgkJCQlyZXR1cm47Ly9ObyBtb3JlIGRhdGEgaW4gc29ja2V0IGJ1Zg0KCQkJ
fQ0KCQl9DQoJCWVsc2UNCgkJew0KCQkJaWYoMD09U2l6ZVJlYWQpDQoJCQl7DQoJCQkJcGVycm9y
KCJwZWVyIGNsb3NlIik7DQoJCQkJcmV0dXJuOw0KCQkJfQ0KCQkJZWxzZQ0KCQkJew0KCQkJCWlm
KEVBR0FJTj09ZXJybm8pDQoJCQkJew0KCQkJCQlyZXR1cm47DQoJCQkJfQ0KCQkJCWVsc2UgaWYo
RUlOVFI9PWVycm5vKQ0KCQkJCXsNCgkJCQkJY29udGludWU7DQoJCQkJfQ0KCQkJCWVsc2UNCgkJ
CQl7DQoJCQkJCXBlcnJvcigic3BsaWNlIik7DQoJCQkJCXJldHVybjsNCgkJCQl9DQoJCQl9DQoJ
CX0NCgl9DQp9DQoNCg==
--000e0cd150b678bea00466fc4d0e--
