Return-Path: <linux-kernel-owner+w=401wt.eu-S932743AbXBTCMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbXBTCMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 21:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932763AbXBTCMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 21:12:12 -0500
Received: from relais.videotron.ca ([24.201.245.36]:64990 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932743AbXBTCMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 21:12:10 -0500
Date: Mon, 19 Feb 2007 21:11:46 -0500
From: Veronique & Vincent <vinctre@videotron.ca>
Subject: Fwd: RE: Boot time Bluetooth BUG: warning: (value > m) at
 hid-core.c:793
To: marcel@holtmann.org, jikos@jikos.cz, vincent.fortier1@ec.gc.ca
Cc: linux-kernel@vger.kernel.org
Message-id: <200702192111.47017.vinctre@videotron.ca>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_21PbliMpRwZPW3ij2IzmMg)"
Content-class: urn:content-classes:message
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Boundary_(ID_21PbliMpRwZPW3ij2IzmMg)
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: quoted-printable
Content-disposition: inline

Hi again Marcel and Jiri,

I've set up the hid-core.c to DEBUG mode... and it literally got pretty ver=
bose...

At line 2114 we finally get the BUG message (I've attached the full dmesg a=
lso...) :
2104 drivers/usb/input/hid-core.c: report (size 8) (unnumbered)
2105 drivers/usb/input/hid-core.c: report 0 (size 8) =3D  00 00 00 00 00 00=
 00 00
2106 hid-debug: input Keyboard.00e0 =3D 0
2107 hid-debug: input Keyboard.00e1 =3D 0
2108 hid-debug: input Keyboard.00e2 =3D 0
2109 hid-debug: input Keyboard.00e3 =3D 0
2110 hid-debug: input Keyboard.00e4 =3D 0
2111 hid-debug: input Keyboard.00e5 =3D 0
2112 hid-debug: input Keyboard.00e6 =3D 0
2113 hid-debug: input Keyboard.00e7 =3D 0
2114 BUG: warning at drivers/usb/input/hid-core.c:797/implement()
2115  [<c0404c70>] dump_trace+0x69/0x1b6
2116  [<c0404dd5>] show_trace_log_lvl+0x18/0x2c
2117  [<c04053bc>] show_trace+0xf/0x11
2118  [<c04054b9>] dump_stack+0x15/0x17
2119  [<c0589a5b>] hid_output_report+0x1f8/0x2a3
2120  [<c0589b5b>] hid_submit_ctrl+0x55/0x214
2121  [<c0589ee7>] hid_submit_report+0x134/0x15f
2122  [<c058c955>] hiddev_ioctl+0x327/0x88a
2123  [<c0479198>] do_ioctl+0x4c/0x62
2124  [<c04793f8>] vfs_ioctl+0x24a/0x25c
2125  [<c0479456>] sys_ioctl+0x4c/0x66
2126  [<c0403de5>] sysenter_past_esp+0x56/0x79
2127  [<b7f8c410>] 0xb7f8c410
2128  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
2129 BUG: warning at drivers/usb/input/hid-core.c:797/implement()
2130  [<c0404c70>] dump_trace+0x69/0x1b6
2131  [<c0404dd5>] show_trace_log_lvl+0x18/0x2c
=2E..
2157  [<b7f8c410>] 0xb7f8c410
2158  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
2159 drivers/usb/input/hid-core.c: submitting ctrl urb: Set_Report wValue=
=3D0x0210 wIndex=3D0x0000 wLength=3D7
2160 BUG: warning at drivers/usb/input/hid-core.c:797/implement()
2161  [<c0404c70>] dump_trace+0x69/0x1b6
=2E..
2184  [<c0479198>] do_ioctl+0x4c/0x62
2185  [<c04793f8>] vfs_ioctl+0x24a/0x25c
2186  [<c0479456>] sys_ioctl+0x4c/0x66
2187  [<c0403de5>] sysenter_past_esp+0x56/0x79
2188  [<b7f8c410>] 0xb7f8c410
2189  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
2190 drivers/usb/input/hid-core.c: submitting ctrl urb: Set_Report wValue=
=3D0x0210 wIndex=3D0x0000 wLength=3D7
2191 drivers/usb/input/hid-core.c: report (size 8) (unnumbered)
2192 drivers/usb/input/hid-core.c: report 0 (size 8) =3D  00 00 00 00 00 00=
 00 00
2193 hid-debug: input Keyboard.00e0 =3D 0
2194 hid-debug: input Keyboard.00e1 =3D 0
2195 hid-debug: input Keyboard.00e2 =3D 0
2196 hid-debug: input Keyboard.00e3 =3D 0
2197 hid-debug: input Keyboard.00e4 =3D 0
2198 hid-debug: input Keyboard.00e5 =3D 0
2199 hid-debug: input Keyboard.00e6 =3D 0
2200 hid-debug: input Keyboard.00e7 =3D 0
2201 drivers/usb/input/hid-core.c: report (size 7) (numbered)
2202 drivers/usb/input/hid-core.c: report 16 (size 6) =3D  ff 80 80 01 00 00
2203 hid-debug: input Undefined.0001 =3D 1
2204 hid-debug: input c06a.8f60 =3D 1
2205 hid-debug: input c06a.8f60 =3D 1
2206 hid-debug: input ff00.0001 =3D 1
2207 BUG: warning at drivers/usb/input/hid-core.c:797/implement()
2208  [<c0404c70>] dump_trace+0x69/0x1b6
2209  [<c0404dd5>] show_trace_log_lvl+0x18/0x2c
2210  [<c04053bc>] show_trace+0xf/0x11
2211  [<c04054b9>] dump_stack+0x15/0x17
2212  [<c0589a5b>] hid_output_report+0x1f8/0x2a3
2213  [<c0589b5b>] hid_submit_ctrl+0x55/0x214
2214  [<c0589ee7>] hid_submit_report+0x134/0x15f
2215  [<c058c955>] hiddev_ioctl+0x327/0x88a
2216  [<c0479198>] do_ioctl+0x4c/0x62
2217  [<c04793f8>] vfs_ioctl+0x24a/0x25c
2218  [<c0479456>] sys_ioctl+0x4c/0x66
2219  [<c0403de5>] sysenter_past_esp+0x56/0x79
2220  [<b7f8c410>] 0xb7f8c410
2221  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
2222 BUG: warning at drivers/usb/input/hid-core.c:797/implement()
=2E..
2249  [<c0403de5>] sysenter_past_esp+0x56/0x79
2250  [<b7f8c410>] 0xb7f8c410
2251  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
2252 drivers/usb/input/hid-core.c: submitting ctrl urb: Set_Report wValue=
=3D0x0210 wIndex=3D0x0000 wLength=3D7
2253 drivers/usb/input/hid-core.c: report (size 7) (numbered)
2254 drivers/usb/input/hid-core.c: report 16 (size 6) =3D  ff 80 00 00 30 00
2255 hid-debug: input ff00.0001 =3D 0
2256 hid-debug: input Button.0001 =3D 1
2257 drivers/usb/input/hid-core.c: report (size 7) (numbered)
2258 drivers/usb/input/hid-core.c: report 16 (size 6) =3D  ff 81 80 01 00 00
2259 hid-debug: input ff00.0001 =3D 1
2260 hid-debug: input Button.0001 =3D 0
2261 Bluetooth: Core ver 2.11
2262 NET: Registered protocol family 31
2263 Bluetooth: HCI device and connection manager initialized
2264 Bluetooth: HCI socket layer initialized
2265 Bluetooth: L2CAP ver 2.8
2266 Bluetooth: L2CAP socket layer initialized
2267 Bluetooth: RFCOMM socket layer initialized
2268 Bluetooth: RFCOMM TTY layer initialized
2269 Bluetooth: RFCOMM ver 1.8
2270 usb 2-2.1: new full speed USB device using uhci_hcd and address 5
2271 drivers/usb/input/hid-core.c: report (size 8) (unnumbered)
2272 drivers/usb/input/hid-core.c: report 0 (size 8) =3D  00 00 00 00 00 00=
 00 00
2273 hid-debug: input Keyboard.00e0 =3D 0
2274 hid-debug: input Keyboard.00e1 =3D 0
2275 hid-debug: input Keyboard.00e2 =3D 0
2276 hid-debug: input Keyboard.00e3 =3D 0
2277 hid-debug: input Keyboard.00e4 =3D 0
2278 hid-debug: input Keyboard.00e5 =3D 0
2279 hid-debug: input Keyboard.00e6 =3D 0
2280 hid-debug: input Keyboard.00e7 =3D 0
2281 usb 2-2.1: configuration #1 chosen from 1 choice
2282 Bluetooth: HCI USB driver ver 2.9
2283 usbcore: registered new interface driver hci_usb
2284 drivers/usb/input/hid-core.c: report (size 7) (numbered)
2285 drivers/usb/input/hid-core.c: report 2 (size 6) =3D  00 00 00 00 00 00
2286 hid-debug: input Button.0001 =3D 0
2287 hid-debug: input Button.0002 =3D 0
2288 hid-debug: input Button.0003 =3D 0
2289 hid-debug: input Button.0004 =3D 0
2290 hid-debug: input Button.0005 =3D 0
2291 hid-debug: input Button.0006 =3D 0
2292 hid-debug: input Button.0007 =3D 0
2293 hid-debug: input Button.0008 =3D 0
2294 hid-debug: input GenericDesktop.X =3D 0
2295 hid-debug: input GenericDesktop.Y =3D 0
2296 hid-debug: input GenericDesktop.Wheel =3D 0
2297 hid-debug: input Consumer.HorizontalWheel =3D 0
2298 hid-debug: input Button.0009 =3D 0
2299 hid-debug: input Button.000a =3D 0
2300 hid-debug: input Button.000b =3D 0
2301 hid-debug: input Button.000c =3D 0
2302 drivers/usb/input/hid-core.c: report (size 8) (unnumbered)
2303 drivers/usb/input/hid-core.c: report 0 (size 8) =3D  00 00 00 00 00 00=
 00 00
2304 hid-debug: input Keyboard.00e0 =3D 0
2305 hid-debug: input Keyboard.00e1 =3D 0
2306 hid-debug: input Keyboard.00e2 =3D 0
2307 hid-debug: input Keyboard.00e3 =3D 0
2308 hid-debug: input Keyboard.00e4 =3D 0
2309 hid-debug: input Keyboard.00e5 =3D 0
2310 hid-debug: input Keyboard.00e6 =3D 0
2311 hid-debug: input Keyboard.00e7 =3D 0
2312 drivers/usb/input/hid-core.c: report (size 5) (numbered)
2313 drivers/usb/input/hid-core.c: report 3 (size 4) =3D  00 00 00 00
2314 drivers/usb/input/hid-core.c: report (size 7) (numbered)
2315 drivers/usb/input/hid-core.c: report 16 (size 6) =3D  ff 44 01 00 00 00
2316 hid-debug: input 01a1.0109 =3D 1
2317 hid-debug: input c06a.8f60 =3D 0
2318 drivers/usb/input/hid-core.c: report (size 2) (numbered)
2319 drivers/usb/input/hid-core.c: report 4 (size 1) =3D  00
2320 drivers/usb/input/hid-core.c: report (size 8) (unnumbered)
2321 drivers/usb/input/hid-core.c: report 0 (size 8) =3D  00 00 00 00 00 00=
 00 00
2322 hid-debug: input Keyboard.00e0 =3D 0
2323 hid-debug: input Keyboard.00e1 =3D 0
2324 hid-debug: input Keyboard.00e2 =3D 0
2325 hid-debug: input Keyboard.00e3 =3D 0
2326 hid-debug: input Keyboard.00e4 =3D 0
2327 hid-debug: input Keyboard.00e5 =3D 0
2328 hid-debug: input Keyboard.00e6 =3D 0
2329 hid-debug: input Keyboard.00e7 =3D 0
2330 Bluetooth: HIDP (Human Interface Emulation) ver 1.1
2331 drivers/usb/input/hid-core.c: report (size 8) (unnumbered)
2332 drivers/usb/input/hid-core.c: report 0 (size 8) =3D  00 00 00 00 00 00=
 00 00
2333 hid-debug: input Keyboard.00e0 =3D 0
2334 hid-debug: input Keyboard.00e1 =3D 0
2335 hid-debug: input Keyboard.00e2 =3D 0
2336 hid-debug: input Keyboard.00e3 =3D 0
2337 hid-debug: input Keyboard.00e4 =3D 0
2338 hid-debug: input Keyboard.00e5 =3D 0
2339 hid-debug: input Keyboard.00e6 =3D 0
2340 hid-debug: input Keyboard.00e7 =3D 0
2341 drivers/usb/input/hid-core.c: report (size 8) (unnumbered)
2342 drivers/usb/input/hid-core.c: report 0 (size 8) =3D  00 00 00 00 00 00=
 00 00
2343 hid-debug: input Keyboard.00e0 =3D 0
2344 hid-debug: input Keyboard.00e1 =3D 0
2345 hid-debug: input Keyboard.00e2 =3D 0
2346 hid-debug: input Keyboard.00e3 =3D 0
2347 hid-debug: input Keyboard.00e4 =3D 0
2348 hid-debug: input Keyboard.00e5 =3D 0
2349 hid-debug: input Keyboard.00e6 =3D 0
2350 hid-debug: input Keyboard.00e7 =3D 0

=2D vin

=2D---------  Message transmis  ----------

Sujet=A0: RE: Boot time Bluetooth BUG: warning: (value > m) at hid-core.c:7=
93
Date=A0: lundi 19 f=E9vrier 2007
De=A0: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>
=C0=A0: Jiri Kosina <jikos@jikos.cz>, Marcel Holtmann <marcel@holtmann.org>

Hi Macel and Jiri,

Thnx for answering!  I'll recompile my kernel when I'll be back home.  Do y=
ou want me to keep my 2.6.19, switch to 2.6.20 or 2.6.21-rcX-gitYZ ?

Thnx.

Note:  Added my home address in CC.

=2D vin

> -----Message d'origine-----
> De : Jiri Kosina [mailto:jikos@jikos.cz]=20
> Envoy=E9 : 19 f=E9vrier 2007 04:37
> =C0 : Marcel Holtmann
> Cc : Fortier,Vincent [Montreal]; linux-kernel@vger.kernel.org
> Objet : Re: Boot time Bluetooth BUG: warning: (value > m) at=20
> hid-core.c:793
>=20
> On Mon, 19 Feb 2007, Marcel Holtmann wrote:
>=20
> > we understand the original CSR HID proxy dongles, but for=20
> the Logitech=20
> > ones, it is wild guesses. The current support in hid2hci has been=20
> > tested on Logitech diNovo first generation and I have no other=20
> > Logitech hardware to verify it with. We might simply need=20
> the full HID=20
> > report descriptor to see who is at fault.
>=20
> Vincent,
>=20
> from the stacktrace it seems that you are using pre-2.6.20=20
> kernel. Could you please compile kernel with the following=20
> changes in drivers/usb/input/hid-core.c
>=20
> - comment the #undef DEBUG and #undef DEBUG_DATA
> - add #define DEBUG and #define DEBUG_DATA
>=20
> and send us the output?
>=20
> --
> Jiri Kosina
>=20

=2D------------------------------------------------------

--Boundary_(ID_21PbliMpRwZPW3ij2IzmMg)
Content-type: application/x-gzip; name=dmesg.2.6.19-DEBUG.gz
Content-transfer-encoding: base64
Content-disposition: attachment; filename=dmesg.2.6.19-DEBUG.gz

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
yDdHvjnyzZFvjnxz5Jsj3xz55sg3R74F8i2Qb4F8C+RbIN8C+RbIt0C+BfItkG+BfAvkWyDfAvkW
yLdAviXyLZFviXxL5Fsi3xL5lsi3RL4l8i2Rb4l8S+RbIt8S+ZbIt0S+Q+Q7RL5D5DtEvkPkO0S+
Q+Q7RL5D5DtEvkPkO0S+Q+Q7RL5D5DskvuJ5GBWMKkZ9jAYYDTEaYTTGaILRFKMZRgcYzTFaYLTE
KPJF/yvofwX9r6D/FfS/gv5X0P8K+l9B/yvofwX9r6D/FfS/gv5X0P8K+l9B/yvofwX9r6D/FfS/
gv5XNPqyi0faK0aSLbO5mLb3bboHb35RVu8ms7vExMP/NlzG5oZP99ROW9LtW6xszgeSyMNJ9OEk
/sNJgoeThA8niR5OEjdJqM6w9aOdF7TzgnZe0M4L2nlBOy9o5wXtvKCdF7TzgnZe0M4L2nlBOy9o
5wXtvKCdF7TzgnZe0M4L2nlBOy9o5wXtvKCdF7TzgnZe0M4L2nlBOy9o5wXtvKCdF7TzgnZe0M4L
2nlBOy9o5wXtvKCdF7TzgnZe0M4L2nlBOy9o5wXtvKCdF7TzgnZe0M4L2nlBOy9o5wXtvKCdF7Tz
gnZe0M4L2nlBOy9o5wXtvKCdF7TzgnZe0M4L2nlBOy9o5wXtvKCdF7TzgnZe0M4L2nlBOy9o5wXt
vKCdF7TzgnZe0M4L2nlBOy9o5wXtvKCdF7TzgnZe0M4L2nlBOy9o5wXtvKCdF7TzgnZe0M4L2nlB
Oy9o5wXtvKCdF7TzgnZe0M4L2nlBOy9o5wXtvKCdF7TzgnZe0M4L2nlBOy9o5wXtvKCdF7TzgnZe
0M4L2nlBOy9o5wXtvKCdF7TzgnZe0M4L2nlBOy9o5wXtvKCdF7TzgnZe0M4L2nlBOy9o5wXtvKCd
F7TzgnZe0M4L2nlBOy9o5wXtvKCdF7TzgnZe0M4L2nlBOy9o5wXtvKCdF7TzgnZe0M4L2nlBOy9o
5wXtvKCdF7TzgnZe0M4L2nlBOy9o5wXtvKCdF7TzgnZe0M4L2nlBOy9o5wXtvKCdF7TzgnZe0M4L
2nlBOy9o5wXtvKCdF7TzgnZe0M4L2nlBOy9o5wXtvKCdF7TzgnZe0M4L2nlBOy9o5wXtvKCdF7Tz
gnZe0M4L2nlBOy9o5wXtvKKdV7TzinZe0c4r2nlFO69o5xXtvKKdV7TzinZe0c4r2nlFO69o5xXt
vKKdV7TzinZe0c4r2nlFO69o5xXtvKKdV7TzinZe0c4r2nlFO69o5xXtvKKdV7TzinZe0c4r2nlF
O694dbai/1X0v4r+V9H/KvpfRf+r6H8V/a+i/1X0v4r+V9H/KvpfRf+r6H8V/a+S/+UbjW5nQ9So
ghVVsKIKVlTBiipYUQUrqmBFFayoghVVsKIKVlTBiipYUQUrqmBFFayoghVVsKIKVlTBiipYUQUr
qmBFFayoghVVsKIKVlTBiipYUQUrqmBFFayoghVVsKIKVlTBiipYUQUrqmBFFayoghVVsKIKVlTB
iipYUQUrqmBFFayoghVVsKIKVlTBiipYUQUrqmBFFayoghVVsKIKVlTBiipYUQUrqmBFFayoghVV
sKIKVlTBiipYUQUrqmBFFayoghVVsKIKVlTBiipYUQUrqmBFFayoghVVsCZ33XYqd912unaT560b
T6OvuS/bu/95LS+rw1npXlBYFsfurYHm5WI8bqdubkgNHr4h1b/z1uzj5iHBx+OyvLw/yaF7HeJ+
9WF6f7I32bvy9eXXsvSJpH7Nvc7/CZC26h6+tfeG5HDoebdv6v1RkS++FdrugL/7GULew48QWuKK
H8Yl6ee8tIv8xyI/pmXc1Nq3No3k4aYRhJ83Db+LdJEucmfkx2zuQfjNm3v7FLlmz/ngA+W6Xeca
sPgLgHU7z/9nO89V40i+oHF0u88u0kX+1rvP73zIaNAW8Kh9X2oaffq00fZNZN/xqFG/u//ip77/
oqudrna62ulqp6udrna62ulqp62d46fPR9PFx21j9kfz61fAzuyR6mhS9tdmv57efg14PRyN7Rdz
UVXv5hvZohjZwazEkvpR5CX9WINt3do283LsCnjimWwxKp4EmgZpFGsadu2i22q72ulqp6udrna6
2ulqp6udrna62vmu2rkoLMmdk53DA6PBn2b/j/3e0asXZs/+eXz0xjQ18MioFyTvds1ell/Yb6/3
X+xs+v7WxuvpaFjNJk1qm6mtLnNUvh/NR9V02/h97er/565/r+9tm7q+OhY3hjt4/Mp4Hwt/mJjN
0ex/bQp/y4zmJjMSBaG3UZ/7lvx7vx+lZvNl9b50NWUkdC3Ei7Y2dvYOD7bN4d6BOVi9sca0yl+3
3YmS050z0/uHsePDd+b0+cvf95qvvx0fuBcsbY7L9+X4kRlXH7Zc+ODov214Y3Sy9+rth8K9+saW
OTb2q3mT1fnFfnVuTuyIc2b224b3Xux6mU0v6b3K6167RDe5f60W7hVl5mDvWdB70RSzfJPZ5h+2
kdkG+0QeufDuzvHTJ95HL4m89fyj6ageZWPb1Iq+uSizWT0os/qJ79nxam42p9WH7Kpa1E9sprK+
sFRPRufV1DenlzbptNrc3XuRhrEX7oTelm27743veWIOn/1r00W3zsym5bbt+y+e/Xvb195gVG8Z
8R6L1/zv7Wbz8sQ8rS/KmR1IG3cORbYDfzvKt7NiOy+WP3r0Zz5fTOanctZQ3rs4P3r6m/v24sBW
qJvYOf711Dszx5fjUe0m3oxm5bF7uZubeXL8Ks8u3dSyvGKSvZ19yOvZ+DSO/KGrzLMmOMnm706j
wC3n2caoLMvE3X/1Np9dubcUrcb9Tg2Mz6vZqL6YmF9evn7+/JeuQ/ipO4Trqtw29o87y1dkdfZ4
kk2z83JSTuvHeTWtZ9XYzOssf/fInI/qnvTtv/563r3q8mo2Or+wNbm35XqHwG2Q4XIb3qtmtqra
NwL+11/vynpWTqt/Ntan794ANO7n1eQfG83k29nULu6vb56ZaeXe41eXeV0WzW+JnwauW7jeMJcv
GzTu1YJ2UWdX5n9Gly7VLxuDfBL4Hz8ud1L391T+5z3V7nVPFWJHFa5+wK76xejSHOzbjjTwveYl
g+/ttH+T4GXTnk01NK7lzrdvZbYRY7e7Jn/ieavswSPzvpwW1cxNa+A/suvXqLdPssoqq+gqa/hZ
1mKp7T7Jq9c/W6zy6hf+rH+dNb476x0/G1znDVZ504d/1nacrranbWu4Du8v24ebv22WHfu2sQtz
cnVZur+rwxOjkOsoK0aVWx6bRb3QPd7GbL7IpovhtnHTtkA7x85wxdiprZsymqymXtjuubB1O7xn
jt0juJ7KrsT0cPfg1bFZBq5bd3+VxHNttDevr8al2z/bZhTbXbP3MY6TrUfG7aJjc3q4d3x4+Ojk
6OD4ZOfk6dn9bVv6+mnb3v+CvXDXaf/MnXZ1kY/aznD4oXdRzV27efVs76Dngsb2zc3BxVbz9sAn
p2J37+bFi4NXT06H2bAc2m6m10zYf9yc7KM5tF17WT85dQf+NnRw9PjgxG1udfmxnj85DR4nZxu5
7bkOXpmm+tqXs3of7ZFKzzbSzG4u+bjMpn1M5ZcuVTC8P1WiLlXyQKq8+cV8GN+bKmtSZQ+U9fdZ
+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

--Boundary_(ID_21PbliMpRwZPW3ij2IzmMg)--
