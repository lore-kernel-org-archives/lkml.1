Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbZHXQA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbZHXQA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbZHXQA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:00:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52703 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbZHXQAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:00:25 -0400
Date: Mon, 24 Aug 2009 12:00:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Build failure on linux-next master branch
In-Reply-To: <20090824113226.b61cccc6.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.0908241156550.7587@gandalf.stny.rr.com>
References: <20090824113226.b61cccc6.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-103232034-1251129625=:7587"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-103232034-1251129625=:7587
Content-Type: TEXT/PLAIN; charset=US-ASCII


With latest next master branch I got this failure in my build system.

  Building modules, stage 2.
Kernel: arch/x86/boot/bzImage is ready  (#1801)
  MODPOST 96 modules
ERROR: "crc16" [net/bluetooth/l2cap.ko] undefined!
make[1]: *** [__modpost] Error 1


Config attached.

-- Steve


--8323328-103232034-1251129625=:7587
Content-Type: APPLICATION/octet-stream; name=config.gz
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.00.0908241200240.7587@gandalf.stny.rr.com>
Content-Description: 
Content-Disposition: attachment; filename=config.gz

H4sICAS5kkoAA2NvbmZpZwCNWGtv2zoS/e5fIQQXaG+RJs6jaVqsd0FLlE1Y
r4qSE6coCMdWYt1rW4El37b76/eQsmPq4W4LtDVnhuTwzJnhUGa2WqWF8TS7
nn28+vDBeHvyVGyms+SzYac/jGKRGLNsPU+LNFtPlxhPC2P7Mp8WSW78sUme
xNN2PTv5s/O4SaZ/58r+cZsu50b2ZMw36T/JJj/Pi+lzun4+XyXpcjHd5sb3
tFgY5TZGsp4+LpP5546h/pim8dX9Zhydix/dm25XzJN/0llylqlpXmZIN6SP
RpEZcCvZJGssDmfz2SZ9KfLzTTLLNvPVLNuui7OXpbFM14lxdfXp1PgX8/5d
Di8/3J6pBVfTv5Ov198+G+/evTO+/q4v3wy62WQb41NnkuSnCqs3uTHbTP/7
8xSoFAqdPC22U+VpWsL1lC2X2XesCwjeY7Qx8myV4BDTHEbMmE3XbxCfabHI
VqdqxiuOpWPGPJktp5skl67vXHqZpQJxy4vNdlZkm7d/GlPAjhAZ6fp3sV1I
f46ut/M+Wy9/HsDH4mdF8qPAD+nMb2406+QyaNX4JOt5DqYZTynYt34uN8oQ
JHWKxo6nxnQ9l+uAy+tEopInhUZR4zEBtCDzdLmUy5UcVqr87Z9nHWbMM4nz
dj2HxwUWU8ebJ8U0XeaSzcUCR86L7dMTXFhKB7Pt80Ly7TCn813mh5y4SZ8X
iBpSCLPevzdeFbuYQTrPpCNphSHMeN4med6po5Evsi2S6hGURrbITRfYDr+m
ayN7/CuZyb0wVJmloJIwdfYw5RKntPhPh0lGrrPCmBqP6TOOh5yWlFslp2Cm
TBn2ZlUuoNJYeqgdHCR6mW6KDuAosxxloJA2swyHmj4nlVOUM7+nAEs6brxs
Mji/kht25im4lOVnnX50h9iB3+kGm67SdbqCT+DaU/pclptFWuyW2i+Q5p87
pu/ZbCBurvss6v3cD+9vbyCqjA8DP46COBK2H7ok6p0ky6eb6/c/bm/e31yf
7G1IaA6FRe1y2DuZbmaLc9iclx7l8jd2AHWfSsnrzAH1aMhMETGXHvbcS03X
5yIOLBJpStPxzRH349Ck4o5E5tDyBy1TpRUdUy/iv1SKfugTyyRcw0NqLRoI
HgeBH2oKHhFzFIUEOzd0QzKmwoGnnjmJ/JbJNvbAiYJ7c6i2IM5B57rxYfDg
e1RYLmn6zTg5ovBdEjTF/bgFGQhFSOEpg8OBz7yIhi0YDe8oGww1/1WQXTIp
TxqYwrbMgza849R9ncwD5kkUa7OHhAsziAWzHBk7nYOvoSEO64eAEXxyyKRp
IJkixnzCYekcWV8e775FB4qS2InU/m1TiTlEDBng5+yB1mLLaRQHIqCh2oKE
lNQMrIlHXHjYblLuwvo09AC97wF6zlm/4QiPeUA9q0W958XVZW1K4AexZB4X
nm9RUaECiS0WKbPGPoqfXPgBIMVxLYGYMY95g2OWFpXcCciAAnrfbOEMCS0W
fmlj004DD4WwfIHfLSwOv4gg9PvamV+LCsKCFD05X6aP56tsvl0m+fkfMQCn
MtqUcHp+Vqst+I9HYWxGvs5v5PuIegIB4K6GEw4eCeqNcWS5lwtuXl1qBYE4
Y6QJ4tY7OalEfYSAUkcMHlhQ48NO04fmsl3lPOjJ3LpSFFKc0NTKAwaoJR7q
cu/m+uAhThbbgg+ZHfUuPlZ2i4EDAZUEB7+tsvod1pMY8gA1TQNJplekZ5cH
vJhkV8NINFJxhBGfuJrl0I8CR69FQYiyo/lQKVTUsRG7UGNBYPJgFIoAJJf3
kDYPcRd2rO9uxxHVcp8Gvq7lbOARx7Y0gFFPQl2g7gVdwIcu1fYkzK9FEwkv
PY5rlXTslmu1qAKTiS8xC0c6nE7cL1OsKtO5gCipiq1Nc0k4qqytXPKRRzZz
6jWM2jYzmfQJqeMAC9CBmAh9fT4D/qgjMh3rd9xIpWh9wiikUatClRDl+dD3
RzUlqpkgUdRwX8kD1oSD9Jlna/iHkXBlwPVtFSm4KznZfUXJt2KnYlRNAuaX
ueH5vpZ8+/uiXbqb0ztZZ9lLo6Op9BgxczRCyX7LDQIS8raeJ4irlg2Bc7G7
qfoT1HytCEilus7VNXDcZteEHFm1LCE3uu4uEHc+yCr0AEpFxM2as+XStW5S
NnLj2vlRcN3YVReljWvTmdScVKFHfXF5qPV+sMZ1pE7pNMXEtZpCEyEgsbbI
MKBRmfZaTF2mhYKEMrqVpozfMT9y+jpjoBdD6gT6Op66+nnv4lDpKHUDSSGP
1gCXl4pkeQ1C5teE5R0/nHBBLCsUUb19x8VKzUgM+vJm5rV5XNEMBWxP26N6
6pGWbgR3K9aG3g8nMot02H+tfF3YJV5M2jS1pN+tA8Q4Qta2Er3Hdag/FA6q
Mf6RBat+ComJ7ZABl5PRV1G9sAcOLv0gkplahu2Vgb+Ae9+GCbnsIdB9FHlT
23jMQKLIR+7Xi5tbLT0HGeqPdFdUo7urNup0yBrlVe+6++k1Q4cP4vJDV1vw
oYexfhImmYYeAM+R7o+LrvrT0Kv7oKlXNChR3UeoeZ2brDLYUbImwxuFeQ1+
7ptLl9fWcOiAmNoDYBhVu8bdY0gmi9Z73ApPS9K4vIDLLAW40RAtZP6Yrs8X
WfGy3B6aRaDjWcSpZKl9hyQllp7fkoGIPAvdO7T39V6QWdps5uHdXBsiSWJO
LTo+JkeLhoLhifveRffy+tc2k97Hm9uqyYhO+j5abb2pLCW4Zkd9nfu4bPza
ULDb7vVlXYj3WMA16Vg7lGyxfRADoHjcUe8avQGK9gZaFO+aMpvdC0pCZ4Kx
qNSF2GP3n26RohOuZ8S4+rJWRLojCLR8y/jobMQgYD4c187C+20vrkFQGcgb
RL+7xgPSdNeKXXfSFINBg8rjyaXMGRKk/+ogkV/wDuM9j0RZvHREAKosCZUF
0V/h1c1rgnqvroSqjrg+HjW+xl6Y6tNdbvkcpmHEJGy1RlNmW1k5m58yQvnu
gude77J7fXsIjHwf6jscPpjo4ZNW+IsHVd/nDc2uyMgHWVuIy72b3y0qco1B
IPEvv9t4flCeV+8QZDLb5QTPZSh/UVONcq/e8e2T99pBSILhb9nY8IPyerdd
3Ua46i3RZrj/+mDX4NbPspuN2uzrNUI32b3mNGDxVFNvS1s/wHFwyoor1RXu
4j+06ZHsoyKzCUjD/vVzT7thCydr5z4an/8Tmj5Kmey3yvdTrW87BvJv4KsY
PBpY/VY5SI/eW28LVEFsPJTLZsFFL9rOZtRr9d1MRJOAiu79bffwBqrr0Apd
tOvi8tvbZbtWQXLV0KnNWh5J2tSDL+WbcVxvASGRZccc6p9A8OQj4Q4Ku8kQ
m3mWrKQ8qjZOFb0nuXdc7ZD6bPk9EC1+tUmVovpXX777Ivs/KzpC2RMcAAA=

--8323328-103232034-1251129625=:7587--
