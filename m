Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbZKCUAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbZKCUAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 15:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbZKCUAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 15:00:42 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:32109 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbZKCUAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 15:00:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:x-face:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=gfgdcEOUUreb2yPju+VZ4S/lfcXJzNZHnC2ylbDbIZFRphPlODWpqdP1RjwuF9r88G
         g73vFSvYJDKKh0BY912PG9jNN2qMCoA97af6GRNYfCMe2SRjBcKgAb+rAECutlK2AgHV
         AGyqlVVoVYwRpsXvM2IIQDOYsDYvr87hiveXE=
From: Pavel Vasilyev <dixlor@gmail.com>
Organization: Pavlinux. Inc
To: linux-kernel@vger.kernel.org
Subject: [ERROR] drivers/scsi/aic7xxx/aicasm
Date: Tue, 3 Nov 2009 23:00:24 +0300
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-default; KDE/4.3.1; x86_64; ; )
X-Face: $dO4505L-bM3\Iz"(
 =?utf-8?q?V=3Dy=2EbL/75=7B5ys3=3AB=5B-aPBQvs*Z=25fdBqFhvc85hmZN4j1kwRzwvY*?=
 =?utf-8?q?R=0A=094=09nvQ/=23/+kWXH?=((aXWh\%mvG1V()Z0k:NwZAIu\S0d1%,nv`^
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1607959.Ix1RLgU48Q";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200911032300.42413.pavel@pavlinux.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1607959.Ix1RLgU48Q
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

 LD      drivers/scsi/aic7xxx/built-in.o    =20
make -C drivers/scsi/aic7xxx/aicasm          =20
*** Install db development libraries
bison -d -b aicasm_gram aicasm_gram.y
mv aicasm_gram.tab.c aicasm_gram.c
mv aicasm_gram.tab.h aicasm_gram.h
gcc -I/usr/include -I. aicasm.c aicasm_symbol.c aicasm_gram.c=20
aicasm_macro_gram.c aicasm_scan.c aicasm_macro_scan.c -o aicasm -ldb
aicasm_symbol.c:48:19: error: aicdb.h: No such file or directory
aicasm_symbol.c:63: error: expected '=3D', ',', ';', 'asm' or '__attribute_=
_'=20
before '*' token
aicasm_symbol.c: In function 'symbol_delete':
aicasm_symbol.c:87: error: 'symtable' undeclared (first use in this functio=
n)
aicasm_symbol.c:87: error: (Each undeclared identifier is reported only once
aicasm_symbol.c:87: error: for each function it appears in.)
aicasm_symbol.c:88: error: 'DBT' undeclared (first use in this function)
aicasm_symbol.c:88: error: expected ';' before 'key'
aicasm_symbol.c:90: error: 'key' undeclared (first use in this function)
aicasm_symbol.c: In function 'symtable_open':
aicasm_symbol.c:134: error: 'symtable' undeclared (first use in this functi=
on)
aicasm_symbol.c:135: error: 'DB_HASH' undeclared (first use in this functio=
n)
aicasm_symbol.c: In function 'symtable_close':
aicasm_symbol.c:148: error: 'symtable' undeclared (first use in this functi=
on)
aicasm_symbol.c:149: error: 'DBT' undeclared (first use in this function)
aicasm_symbol.c:149: error: expected ';' before 'key'
aicasm_symbol.c:150: error: expected ';' before 'data'
aicasm_symbol.c:152: error: 'key' undeclared (first use in this function)
aicasm_symbol.c:152: error: 'data' undeclared (first use in this function)
aicasm_symbol.c:152: error: 'R_FIRST' undeclared (first use in this functio=
n)
aicasm_symbol.c: In function 'symtable_get':
aicasm_symbol.c:170: error: 'DBT' undeclared (first use in this function)
aicasm_symbol.c:170: error: expected ';' before 'key'
aicasm_symbol.c:171: error: expected ';' before 'data'
aicasm_symbol.c:174: error: 'key' undeclared (first use in this function)
aicasm_symbol.c:177: error: 'symtable' undeclared (first use in this functi=
on)
aicasm_symbol.c:177: error: 'data' undeclared (first use in this function)
aicasm_symbol.c: In function 'symtable_dump':
aicasm_symbol.c:479: error: 'DBT' undeclared (first use in this function)
aicasm_symbol.c:479: error: expected ';' before 'key'
aicasm_symbol.c:480: error: expected ';' before 'data'
aicasm_symbol.c:485: error: 'symtable' undeclared (first use in this functi=
on)
aicasm_symbol.c:494: error: 'R_FIRST' undeclared (first use in this functio=
n)
aicasm_symbol.c:495: error: 'key' undeclared (first use in this function)
aicasm_symbol.c:495: error: 'data' undeclared (first use in this function)
aicasm_symbol.c:532: error: 'R_NEXT' undeclared (first use in this function)
make[4]: *** [aicasm] Error 1
make[3]: *** [drivers/scsi/aic7xxx/aicasm/aicasm] Error 2
make[2]: *** [drivers/scsi/aic7xxx] Error 2
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

--nextPart1607959.Ix1RLgU48Q
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkrwi+oACgkQOqfDywN0JInkywCfWIJUMv2hZYiQTEaR2jg/W9o6
v7AAn2b6PLyIna/IdyAotBzIaQY7PW50
=CBSY
-----END PGP SIGNATURE-----

--nextPart1607959.Ix1RLgU48Q--
